{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  glib,
  gtk4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pantheon-wayland";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-wayland";
    rev = finalAttrs.version;
    hash = "sha256-Wfulo/fXsb51ShT7E2wTg56TULAK1chB59L/ggGh2EY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
  ];

  propagatedBuildInputs = [
    glib
    gtk4
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland integration library to the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-wayland";
    license = lib.licenses.lgpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
})
