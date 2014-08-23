{ stdenv, fetchurl, pkgconfig, glib, ncurses, mpd_clientlib, libintlOrEmpty }:

stdenv.mkDerivation rec {
  version = "0.23";
  name = "ncmpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/ncmpc/0/ncmpc-${version}.tar.xz";
    sha256 = "d7b30cefaf5c74a5d8ab18ab8275e0102ae12e8ee6d6f8144f8e4cc9a97b5de4";
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

