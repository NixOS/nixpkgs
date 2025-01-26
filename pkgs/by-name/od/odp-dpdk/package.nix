{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  dpdk,
  libbpf,
  libconfig,
  libpcap,
  numactl,
  openssl,
  zlib,
  zstd,
  libbsd,
  elfutils,
  jansson,
  libnl,
}:

stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.44.0.0_DPDK_22.11";

  src = fetchFromGitHub {
    owner = "OpenDataPlane";
    repo = "odp-dpdk";
    rev = "v${version}";
    hash = "sha256-hYtQ7kKB08BImkTYXqtnv1Ny1SUPCs6GX7WOYks8iKA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    dpdk
    libconfig
    libpcap
    numactl
    openssl
    zlib
    zstd
    libbsd
    elfutils
    jansson
    libbpf
    libnl
  ];

  # binaries will segfault otherwise
  dontStrip = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = "https://www.opendataplane.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.abuibrahim ];
  };
}
