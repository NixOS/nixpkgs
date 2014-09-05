{ stdenv, fetchurl, alsaLib, boost, cmake, glib, jack2, libarchive
, liblrdf, libsndfile, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  version = "0.9.6";
  name = "hydrogen-${version}";

  src = fetchurl {
    url = "https://github.com/hydrogen-music/hydrogen/archive/${version}.tar.gz";
    sha256 = "1z7j8aq158mp41iv78j0w6fyx98y1y51z592b4x5hkvicabgck5w";
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
