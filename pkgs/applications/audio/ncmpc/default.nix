{ stdenv, fetchurl, pkgconfig, glib, ncurses, mpd_clientlib }:

stdenv.mkDerivation rec {
  version = "0.21";
  name = "ncmpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/ncmpc/0/ncmpc-${version}.tar.bz2";
    sha256 = "648e846e305c867cb937dcb467393c2f5a30bf460bdf77b63de7af69fba1fd07";
  };

  buildInputs = [ pkgconfig glib ncurses mpd_clientlib ];

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ _1126 ];
    platforms   = platforms.all;
  };
}

