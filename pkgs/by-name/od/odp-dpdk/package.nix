{
  lib,
  stdenv,
  fetchFromGitHub,
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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odp-dpdk";
  version = "1.51.0.0_DPDK_24.11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenDataPlane";
    repo = "odp-dpdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6lF8VaycAz7PcFArAgLhI8+sc0jnAHY3gum/uDIYz4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    dpdk
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Data Plane optimized for DPDK";
    homepage = "https://www.opendataplane.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      abuibrahim
      stepbrobd
    ];
  };
})
