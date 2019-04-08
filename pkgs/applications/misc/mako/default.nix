{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc, systemd, pango, cairo
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "mako-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mako";
    rev = "v${version}";
    sha256 = "112b7s5bkvwlgsm2kng2vh8mn6wr3a6c7n1arl9adxlghdym449h";
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
