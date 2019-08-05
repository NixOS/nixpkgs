{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc
, systemd, pango, cairo, gdk-pixbuf
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "11ymiq6cr2ma0iva1mqybn3j6k73bsc6lv6pcbdq7hkhd4f9b7j9";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc wayland-protocols ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  mesonFlags = [ "-Dzsh-completions=true" ];

  meta = with stdenv.lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = https://wayland.emersion.fr/mako/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
