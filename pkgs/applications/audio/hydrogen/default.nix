{ stdenv, fetchurl, alsaLib, boost, cmake, glib, jack2, libarchive
, liblrdf, libsndfile, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  version = "0.9.6.1";
  name = "hydrogen-${version}";

  src = fetchurl {
    url = "https://github.com/hydrogen-music/hydrogen/archive/${version}.tar.gz";
    sha256 = "0vxnaqfmcv7hhk0cj67imdcqngspnck7f0wfmvhfgfqa7x1xznll";
  };

  buildInputs = [ 
    alsaLib boost cmake glib jack2 libarchive liblrdf libsndfile pkgconfig qt4
  ];

  meta = with stdenv.lib; {
    description = "Advanced drum machine";
    homepage = http://www.hydrogen-music.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
