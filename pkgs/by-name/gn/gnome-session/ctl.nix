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
  version = "47.0.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "gnome-session-ctl";
    rev = version;
    hash = "sha256-RY0+iIwwjd7268m3EYrZ1yUBLHXmaWddtSxqgUUH6qQ=";
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
