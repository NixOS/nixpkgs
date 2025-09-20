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

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "128.0-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    # Backport fixes to support GLib 2.86.0 typelibs
    # nixpkgs-update: no auto update
    # https://github.com/linuxmint/cjs/issues/130
    rev = "1f39576bafe6bc05bce960e590dc743dd7990e39";
    hash = "sha256-drKLaTZLIZfPIhcVcCAB48PdM2b0GNLe5xrHGBysVmM=";
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

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cjs";
    description = "JavaScript bindings for Cinnamon";

    longDescription = ''
      This module contains JavaScript bindings based on gobject-introspection.
    '';

    license = with licenses; [
      gpl2Plus
      lgpl2Plus
      mit
      mpl11
    ];

    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
