{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  pkg-config,
  cairo,
  glib,
  readline,
  libsysprof-capture,
  spidermonkey_128,
  meson,
  mesonEmulatorHook,
  dbus,
  ninja,
  which,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cjs";
  version = "128.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    tag = finalAttrs.version;
    hash = "sha256-YJwzFKEOnwBTJUPagXk1PCYmQqVqr7Zu7aVaJCPgirU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    which # for locale detection
    libxml2 # for xml-stripblanks
    dbus # for dbus-run-session
    gobject-introspection
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    cairo
    readline
    libsysprof-capture
    spidermonkey_128
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = lib.optionals stdenv.hostPlatform.isMusl [
    "-Dprofiler=disabled"
  ];

  postPatch = ''
    patchShebangs --build build/choose-tests-locale.sh
  '';

  meta = {
    homepage = "https://github.com/linuxmint/cjs";
    description = "JavaScript bindings for Cinnamon";

    longDescription = ''
      This module contains JavaScript bindings based on gobject-introspection.
    '';

    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
      mit
      mpl11
    ];

    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
