{ stdenv, fetchurl, ncurses, curl, taglib, fftw, mpd_clientlib, pkgconfig
, boost, readline, libiconvOrEmpty }:

stdenv.mkDerivation rec {
  version = "0.6_beta5";
  name = "ncmpcpp-${version}";

  src = fetchurl {
    url = "http://ncmpcpp.rybczak.net/stable/ncmpcpp-${version}.tar.bz2";
    sha256 = "05h4mahnh39y9ab333whsgspj5mnbdkqfssgfi4r0zf1fvjwlwj6";
  };

  buildInputs = [ ncurses curl taglib fftw mpd_clientlib pkgconfig boost readline ]
    ++ libiconvOrEmpty;

  configureFlags = [
    "BOOST_LIB_SUFFIX="
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://unkart.ovh.org/ncmpcpp/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms   = platforms.all;
  };
}

