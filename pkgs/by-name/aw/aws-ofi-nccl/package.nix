{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  libtool,
  cudaPackages,
  libfabric,
  hwloc,
}:

stdenv.mkDerivation {
  name = "aws-ofi-nccl";
  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-ofi-nccl";
    rev = "v1.13.2-aws";
    hash = "sha256-nOoGVNut17GbAIasRxRo1qsJQiSYwWWSmQFjAC756hw=";
  };
  nativeBuildInputs = [
    automake
    autoconf
    libtool
  ];

  propagatedBuildInputs = [
    cudaPackages.nccl
    cudaPackages.cuda_cudart
    libfabric
    hwloc
  ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "";
    longDescription = ''
      AWS OFI NCCL is a plug-in which enables EC2 developers to use
      libfabric as a network provider while running NVIDIA's NCCL
      based applications.
    '';
    homepage = "https://github.com/aws/aws-ofi-nccl";
    license = licenses.asl20;
    maintainers = with maintainers; [ sielicki ];
    platforms = cudaPackages.nccl.meta.platforms;
  };
}
