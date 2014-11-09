{ stdenv, fetchurl, ncurses, curl, taglib, fftw, mpd_clientlib, pkgconfig
, libiconvOrEmpty, boost, readline }:

stdenv.mkDerivation rec {
  version = "0.6.1";
  name = "ncmpcpp-${version}";

  src = fetchurl {
    url = "http://ncmpcpp.rybczak.net/stable/ncmpcpp-${version}.tar.bz2";
    sha256 = "033a18hj0q0smm5n0ykld9az7w95myr7jm2b1bjm0h2q5927x8qm";
  };

  configureFlags = "BOOST_LIB_SUFFIX=";

  buildInputs = [ ncurses curl taglib fftw mpd_clientlib boost pkgconfig readline ]
    ++ libiconvOrEmpty;

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://unkart.ovh.org/ncmpcpp/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 mornfall ];
    platforms   = platforms.all;
  };
}
