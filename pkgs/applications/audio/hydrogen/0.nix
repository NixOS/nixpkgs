{ stdenv, fetchurl, pkgconfig, cmake
, alsaLib, boost, glib, lash, libjack2, libarchive, libsndfile, lrdf, qt4
}:

stdenv.mkDerivation rec {
  version = "0.9.7";
  pname = "hydrogen";

  src = fetchurl {
    url = "https://github.com/hydrogen-music/hydrogen/archive/${version}.tar.gz";
    sha256 = "1dy2jfkdw0nchars4xi4isrz66fqn53a9qk13bqza7lhmsg3s3qy";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    alsaLib boost glib lash libjack2 libarchive libsndfile lrdf qt4
  ];

  meta = with stdenv.lib; {
    description = "Advanced drum machine";
    homepage = "http://www.hydrogen-music.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
