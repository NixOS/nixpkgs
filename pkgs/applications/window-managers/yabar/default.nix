{ stdenv, fetchFromGitHub, cairo, gdk_pixbuf, libconfig, pango, pkgconfig, xcbutilwm }:

let
  version = "0.4.0";
in

stdenv.mkDerivation rec {
  name = "yabar-${version}";

  src = fetchFromGitHub {
    owner = "geommer";
    repo = "yabar";
    rev = "746387f0112f9b7aa2e2e27b3d69cb2892d8c63b";
    sha256 = "1nw9dar1caqln5fr0dqk7dg6naazbpfwwzxwlkxz42shsc3w30a6";
  };

  buildInputs = [ cairo gdk_pixbuf libconfig pango pkgconfig xcbutilwm ];

  buildPhase = ''
    substituteInPlace ./Makefile --replace "\$(shell git describe)" "${version}"
    make DESTDIR=$out PREFIX=/
  '';

  installPhase = ''
    make DESTDIR=$out PREFIX=/ install
  '';

  meta = with stdenv.lib; {
    description = "A modern and lightweight status bar for X window managers";
    homepage = "https://github.com/geommer/yabar";
    maintainers = [ maintainers.hiberno ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
