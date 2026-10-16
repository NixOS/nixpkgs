{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pkg-config,
  expat,
  gettext,
  libiconv,
  dbus,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-glib";
  version = "0.116";

  src = fetchurl {
    url = "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-4/PUSH4og4AHcO1Yme0RG9xLpwVq80olXExGrYokhvM=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  nativeBuildInputs = [
    pkg-config
    gettext
    glib
  ];

  buildInputs = [
    expat
    libiconv
  ];

  propagatedBuildInputs = [
    dbus
    glib
  ];

  configureFlags = [
    "--exec-prefix=${placeholder "dev"}"
  ]
  ++ lib.optional (
    stdenv.buildPlatform != stdenv.hostPlatform
  ) "--with-dbus-binding-tool=${buildPackages.dbus-glib.dev}/bin/dbus-binding-tool";

  doCheck = false;

  passthru = { inherit dbus glib; };

  meta = {
    changelog = "https://gitlab.freedesktop.org/dbus/dbus-glib/-/blob/dbus-glib-${finalAttrs.version}/NEWS";
    homepage = "https://dbus.freedesktop.org";
    license = with lib.licenses; [
      afl21
      gpl2Plus
    ];
    description = "Obsolete glib bindings for D-Bus lightweight IPC mechanism";
    mainProgram = "dbus-binding-tool";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
