{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  pkg-config,
  dpdk,
  intel-ipsec-mb,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "odp-dpdk";
  version = "1.46.0.0_DPDK_22.11";

  src = fetchFromGitHub {
    owner = "OpenDataPlane";
    repo = "odp-dpdk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9stWGupRSQwUXOdPEQ9Rhkim22p5BBA5Z+2JCYS7Za0=";
  };

  patches = [
    ./odp-dpdk_25.03.patch
    # Fix gcc 15 -Wunterminated-string-initialization errors in test code.
    (fetchpatch2 {
      url = "https://github.com/OpenDataPlane/odp-dpdk/commit/56c6bdbe8fe9db4c0441162ec269ef4e1ebd1a6a.patch";
      hash = "sha256-aj4HuGb0BUxsKtFS3X3gXqBoRVRnKEBNxa/4heWhBlE=";
    })
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
    intel-ipsec-mb
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

  meta = {
    description = "Open Data Plane optimized for DPDK";
    homepage = "https://www.opendataplane.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.abuibrahim ];
  };
})
