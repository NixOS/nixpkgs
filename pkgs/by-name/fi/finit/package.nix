{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  hwdata,
  kmod,
  libcap,
  libconfuse,
  libite,
  libuev,
  libxcrypt,
  shadow,
  sysctl,
  util-linuxMinimal,
  udevSupport ? false,
  plymouth,
  plymouthSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "finit";
  version = "5.0-rc1";

  src = fetchFromGitHub {
    owner = "finit-project";
    repo = "finit";
    tag = finalAttrs.version;
    hash = "sha256-RN1ec0SNsajmcKGFWkot550wXDCub71MDto0KsLovcY=";
  };

  postPatch = ''
    substituteInPlace plugins/modprobe.c --replace-fail \
      '"/lib/modules"' '"/run/booted-system/kernel-modules/lib/modules"'

    substituteInPlace plugins/modules-load.c --replace-fail \
      '"/sbin/modprobe"' '"${kmod}/bin/modprobe"'
  ''
  + lib.optionalString udevSupport ''
    substituteInPlace keventd/uevent.c \
      --replace-fail '"/sbin/modprobe", "modprobe"' '"${kmod}/bin/modprobe", "modprobe"' \
      --replace-fail '"/usr/lib/firmware/' '"/run/current-system/firmware/lib/firmware/'

    substituteInPlace keventd/builtin.c \
      --replace-fail  '"/lib/udev/hwdb.d"' '"/run/current-system/sw/lib/udev/hwdb.d"' \
      --replace-fail  '"/usr/share/hwdata/usb.ids"' '"${hwdata}/share/hwdata/usb.ids"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libcap
    libconfuse
    libite
    libuev
    libxcrypt
  ]
  ++ lib.optionals udevSupport [ util-linuxMinimal ];

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"

    (lib.withFeature true "libsystemd")
    (lib.enableFeature plymouthSupport "plymouth-plugin")
    (lib.withFeature udevSupport "keventd")

    # tweak default plugin list
    (lib.enableFeature false "dbus-plugin")
    (lib.enableFeature false "hotplug-plugin")
    (lib.enableFeature true "modules-load-plugin")
  ];

  installFlags = [
    "dbuspolicydir=${placeholder "out"}/etc/dbus-1/system.d"
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
