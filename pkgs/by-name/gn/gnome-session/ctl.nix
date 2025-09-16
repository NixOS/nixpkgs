{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  systemd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-session-ctl";
  version = "49.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "gnome-session-ctl";
    rev = version;
    hash = "sha256-rudb7ioTE5iaou0tzU5i2gWFW06NyWF5W5tjx2b5/0Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    systemd
  ];

  meta = with lib; {
    description = "gnome-session-ctl extracted from gnome-session for nixpkgs";
    homepage = "https://github.com/nix-community/gnome-session-ctl";
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
}
