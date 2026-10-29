{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  dpdk,
  libbsd,
  libpcap,
  numactl,
  util-linux,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pktgen";
  version = "26.03.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "pktgen";
    repo = "Pktgen-DPDK";
    tag = "pktgen-${finalAttrs.version}";
    hash = "sha256-GNBo0WsHevoge97gUgDdNygCHSA5fQ/73ibsTvDvVYI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dpdk
    libbsd
    libpcap
    numactl
  ];

  env = {
    RTE_SDK = dpdk;
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=sign-compare"
      "-Wno-error=unused-but-set-variable"
    ];
    # requires symbols from this file
    NIX_LDFLAGS = "-lrte_net_bond";
  };

  postPatch = ''
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${lib.getExe' util-linux "lscpu"}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Traffic generator powered by DPDK";
    homepage = "http://dpdk.org/";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      abuibrahim
      stepbrobd
    ];
  };
})
