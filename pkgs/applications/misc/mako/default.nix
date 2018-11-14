{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc, systemd, pango, cairo
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "mako-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mako";
    rev = "v${version}";
    sha256 = "18krsyp9g6f689024dn1mq8dyj4yg8c3kcy5s88q1gm8py6c4493";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ systemd pango cairo wayland wayland-protocols ];

  meta = with stdenv.lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = https://wayland.emersion.fr/mako/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
