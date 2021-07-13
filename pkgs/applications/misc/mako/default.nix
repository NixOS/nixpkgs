{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, scdoc
, systemd, pango, cairo, gdk-pixbuf
, wayland, wayland-protocols
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RcPwZ5NeO9vxwPWfgj5x3wVdCYGKumnYT3ngHEAWfW0=";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-protocols wrapGAppsHook ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  mesonFlags = [
    "-Dzsh-completions=true"
    "-Dsd-bus-provider=libsystemd"
  ];

  meta = with lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = "https://wayland.emersion.fr/mako/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir synthetica ];
    platforms = platforms.linux;
  };
}
