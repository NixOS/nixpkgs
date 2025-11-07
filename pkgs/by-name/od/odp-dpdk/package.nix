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
  version = "1.46.0.0_DPDK_22.11";

  src = fetchFromGitHub {
    owner = "OpenDataPlane";
    repo = "odp-dpdk";
    rev = "v${version}";
    hash = "sha256-9stWGupRSQwUXOdPEQ9Rhkim22p5BBA5Z+2JCYS7Za0=";
  };

  patches = [
    ./odp-dpdk_25.03.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    (dpdk.overrideAttrs {
      patches = [
        ./dpdk_25.03.patch
      ];
    })
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
