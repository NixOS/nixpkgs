{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libcap,
  libite,
  libuev,
  shadow,
  sysctl,
  plymouth,
  plymouthSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "finit";
  version = "4.17";

  src = fetchFromGitHub {
    owner = "finit-project";
    repo = "finit";
    tag = finalAttrs.version;
    hash = "sha256-sH4xZNMEuIS+r6rVQAKnsHtSyTe2B6gdYcmH9J8eSZ0=";
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
  ]
  ++ lib.optionals plymouthSupport [
    "--enable-plymouth-plugin=yes"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-D_PATH_LOGIN=\"${shadow}/bin/login\""
      "-DSYSCTL_PATH=\"${sysctl}/bin/sysctl\""
    ]
    ++ lib.optionals plymouthSupport [
      "-DPLYMOUTH_PATH=\"${plymouth}/bin/plymouth\""
      "-DPLYMOUTHD_PATH=\"${plymouth}/bin/plymouthd\""
    ]
  );

  meta = {
    description = "Fast init for Linux";
    mainProgram = "initctl";
    homepage = "https://troglobit.com/projects/finit/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aanderse ];
    platforms = lib.platforms.unix;
  };
})
