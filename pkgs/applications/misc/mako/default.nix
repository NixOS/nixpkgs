{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc
, systemd, pango, cairo, gdk_pixbuf
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "17azdc37xsbmx13fkfp23vg9lznrv9fh6nhagn64wdq3nhsxm3b6";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc wayland-protocols ];
  buildInputs = [ systemd pango cairo gdk_pixbuf wayland ];

  mesonFlags = [
    "-Dicons=enabled" "-Dman-pages=enabled" "-Dzsh-completions=true"
  ];

  meta = with stdenv.lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = https://wayland.emersion.fr/mako/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
