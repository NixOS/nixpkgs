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
  lua5_3,
  numactl,
  util-linux,
  gtk2,
  which,
  withGtk ? false,
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
    lua5_3
    numactl
    which
  ]
  ++ lib.optionals withGtk [
    gtk2
  ];

  env = {
    RTE_SDK = dpdk;
    GUI = lib.optionalString withGtk "true";

    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=sign-compare"
    ];
    # requires symbols from this file
    NIX_LDFLAGS = "-lrte_net_bond";
  };

  postPatch = ''
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${lib.getExe' util-linux "lscpu"}
  '';

  postInstall = ''
    # meson installs unneeded files with conflicting generic names, such as
    # include/cli.h and lib/liblua.so.
    rm -rf $out/include $out/lib
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
