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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pktgen";
  version = "24.10.3";

  src = fetchFromGitHub {
    owner = "pktgen";
    repo = "Pktgen-DPDK";
    rev = "pktgen-${finalAttrs.version}";
    sha256 = "sha256-6KC1k+LWNSU/mdwcUKjCaq8pGOcO+dFzeXX4PJm0QgE=";
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

  RTE_SDK = dpdk;
  GUI = lib.optionalString withGtk "true";

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=sign-compare"
  ];

  # requires symbols from this file
  NIX_LDFLAGS = "-lrte_net_bond";

  postPatch = ''
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${util-linux}/bin/lscpu
  '';

  postInstall = ''
    # meson installs unneeded files with conflicting generic names, such as
    # include/cli.h and lib/liblua.so.
    rm -rf $out/include $out/lib
  '';

  meta = {
    description = "Traffic generator powered by DPDK";
    homepage = "http://dpdk.org/";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.abuibrahim ];
  };
})
