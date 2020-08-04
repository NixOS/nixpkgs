{ lib, stdenv, fetchFromGitHub
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk3
, hicolor-icon-theme
, meson
, ninja
, pkg-config
, python3
, systemd
, wrapGAppsHook
}:

let
  # use pythonEnv, so that patchShebang fixup will choose this interpreter
  pythonEnv = python3.withPackages(ps: with ps; [
    pygobject3
    dbus-python
  ]);
in

stdenv.mkDerivation rec {
  pname = "cpupower-gui";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "vagnum08";
    repo = pname;
    rev = "v${version}";
    sha256 = "0iklhnsw76mclzj177kg8zd6jvg0rpmsslr5mwddv6n0ayx2sj7m";
  };

  nativeBuildInputs = [
    hicolor-icon-theme # needed for postinstall script
    desktop-file-utils # needed for update-desktop-database
    meson
    ninja
    glib # needed for glib-compile-scemas
    pkg-config
    wrapGAppsHook
    gettext
    pythonEnv
    gtk3
    gobject-introspection # need for gtk namespace to be available
  ];

  mesonFlags = [
    "--datadir=${placeholder "out"}/share"
    "-Dsystemddir=${placeholder "out"}"
  ];

  preConfigure = ''
    patchShebangs ./build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Change the frequency limits of your cpu and its governor";
    homepage = "https://github.com/vagnum08/cpupower-gui/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jonringer ];
  };
}
