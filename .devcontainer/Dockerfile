FROM mcr.microsoft.com/devcontainers/cpp:1-ubuntu-24.04

# Install gcc 14
COPY ./install-gcc.sh /tmp/
RUN  chmod +x /tmp/install-gcc.sh && /tmp/install-gcc.sh && rm -f /tmp/install-gcc.sh
