{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libite,
  libuev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "finit";
  version = "4.14";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "finit";
    tag = finalAttrs.version;
    hash = "sha256-v4QHc6pX50z4j4UBpw7J2k78Pqt7n503qiDRDWyrhOc=";
  };

  postPatch = ''
    substituteInPlace plugins/modprobe.c --replace-fail \
      '"/lib/modules"' '"/run/booted-system/kernel-modules/lib/modules"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libite
    libuev
  ];

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"

    # tweak default plugin list
    "--enable-modules-load-plugin=yes"
    "--enable-hotplug-plugin=no"

    # minimal replacement for systemd notification library
    "--with-libsystemd"

    # monitor kernel events, like ac power status
    "--with-keventd"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-D_PATH_LOGIN=\"/run/current-system/sw/bin/login\""
    "-DSYSCTL_PATH=\"/run/current-system/sw/bin/sysctl\""
  ];

  meta = {
    description = "Fast init for Linux";
    mainProgram = "initctl";
    homepage = "https://troglobit.com/projects/finit/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aanderse ];
    platforms = lib.platforms.unix;
  };
})
