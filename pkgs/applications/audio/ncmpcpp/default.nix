{stdenv, fetchurl, ncurses, curl, taglib, fftw, mpd_clientlib, pkgconfig}:

stdenv.mkDerivation rec {
  version = "0.5.8";
  name = "ncmpcpp-${version}";

  src = fetchurl {
    url = "http://unkart.ovh.org/ncmpcpp/ncmpcpp-${version}.tar.bz2";
    sha256 = "1kbkngs4fhf9z53awskqiwdl94i5slvxmjiajkrayi99373fallx";
  };

  buildInputs = [ ncurses curl taglib fftw mpd_clientlib pkgconfig ];

  meta = {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage = http://unkart.ovh.org/ncmpcpp/;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
}

