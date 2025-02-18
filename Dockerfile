# Use an official PyTorch image as the base image
FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update
RUN apt-get install -y \
    git \
    python3-pip \
    cuda-compiler-11-3

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        nvidia-cuda-toolkit

RUN uname -m
RUN python3 --version

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --verbose -r requirements.txt

COPY requirements-torch.txt ./
RUN pip install --verbose -r requirements-torch.txt

COPY requirements-misc.txt ./
RUN pip install --verbose -r requirements-misc.txt

#RUN apt install assimp-utils npm \
#    && npm install -g obj2gltf

#RUN rm -rf /var/lib/apt/lists/*

COPY init ./
COPY run ./

RUN ./init
WORKDIR /app/source

COPY binvox ./

RUN ./init

CMD [ "/bin/bash", "start" ]
