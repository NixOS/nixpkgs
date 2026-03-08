{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libcap,
  libite,
  libuev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "finit";
  version = "4.16";

  src = fetchFromGitHub {
    owner = "finit-project";
    repo = "finit";
    tag = finalAttrs.version;
    hash = "sha256-DtocGgFvt7RLqwjHczwUbsszBD5MQI5fEuq9EB2tFp4=";
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
    libcap
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
