{ stdenv, fetchurl, ncurses, curl, taglib, fftw, mpd_clientlib, pkgconfig
, libiconvOrEmpty }:

stdenv.mkDerivation rec {
  version = "0.5.10";
  name = "ncmpcpp-${version}";

  src = fetchurl {
    url = "http://ncmpcpp.rybczak.net/stable/ncmpcpp-${version}.tar.bz2";
    sha256 = "ff6d5376a2d9caba6f5bb78e68af77cefbdb2f04cd256f738e39f8ac9a79a4a8";
  };

  buildInputs = [ ncurses curl taglib fftw mpd_clientlib pkgconfig ]
    ++ libiconvOrEmpty;

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://unkart.ovh.org/ncmpcpp/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 mornfall ];
    platforms   = platforms.all;
  };
}

