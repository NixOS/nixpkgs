{ stdenv, fetchurl, pkgconfig, glib, ncurses, mpd_clientlib, libintlOrEmpty }:

stdenv.mkDerivation rec {
  version = "0.24";
  name = "ncmpc-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/ncmpc/0/ncmpc-${version}.tar.xz";
    sha256 = "1sf3nirs3mcx0r5i7acm9bsvzqzlh730m0yjg6jcyj8ln6r7cvqf";
  };

  buildInputs = [ pkgconfig glib ncurses mpd_clientlib ]
    ++ libintlOrEmpty;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  configureFlags = [
    "--enable-colors"
    "--enable-lyrics-screen"
  ];

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ _1126 ];
    platforms   = platforms.all;
  };
}

