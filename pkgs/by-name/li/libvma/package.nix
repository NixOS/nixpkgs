{
  lib,
  pkg-config,
  autoreconfHook,
  rdma-core,
  libnl,
  libcap,
  fetchFromGitHub,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = src.repo;
  version = src.rev;
  src = fetchFromGitHub {
    repo = "libvma";
    owner = "Mellanox";
    rev = "9.8.84";
    hash = "sha256-vm9yeoW65HdkzGhoV9cdNf7sEIgloxFNXM/Bqfp7als=";
  };
  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    rdma-core
    libnl
    libcap
  ];
  meta = {
    description = "Linux user space library for network socket acceleration based on RDMA compatible network adaptors";
    homepage = "https://github.com/${src.owner}/${src.repo}/tree/${src.rev}";
    maintainers = [ lib.maintainers.birdee ];
  };
}
