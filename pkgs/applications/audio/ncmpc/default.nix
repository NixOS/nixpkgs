{ stdenv, fetchurl, pkgconfig, glib, ncurses, mpd_clientlib, libintlOrEmpty }:

stdenv.mkDerivation rec {
  version = "0.22";
  name = "ncmpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/ncmpc/0/ncmpc-${version}.tar.xz";
    sha256 = "a8d65f12653d9ce8bc4493aa1c5de09359c25bf3a22498d2ae797e7d41422211";
  };

  buildInputs = [ pkgconfig glib ncurses mpd_clientlib ]
    ++ libintlOrEmpty;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ _1126 ];
    platforms   = platforms.all;
  };
}

