{ stdenv, fetchurl, ncurses, curl, taglib, fftw, mpd_clientlib, pkgconfig
, libiconvOrEmpty, boost, readline }:

stdenv.mkDerivation rec {
  version = "0.6.2";
  name = "ncmpcpp-${version}";

  src = fetchurl {
    url = "http://ncmpcpp.rybczak.net/stable/ncmpcpp-${version}.tar.bz2";
    sha256 = "1mrd6m6ph0fscxp9x96ipxh6ai7w0n1miapcfqrqfy058qx5zbck";
  };

  configureFlags = "BOOST_LIB_SUFFIX=";

  buildInputs = [ ncurses curl taglib fftw mpd_clientlib boost pkgconfig readline ]
    ++ libiconvOrEmpty;

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://unkart.ovh.org/ncmpcpp/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 mornfall koral ];
    platforms   = platforms.all;
  };
}
