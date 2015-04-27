{ stdenv, fetchurl, makeWrapper, cmake, qt5, pkgconfig, alsaLib, portaudio, jack2
, lame, libsndfile, libvorbis }:

stdenv.mkDerivation rec {
  name = "musescore-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/musescore/MuseScore/archive/v${version}.tar.gz";
    sha256 = "1a4fz9pqwz59brfa7qn61364hyd07lsq3lflkzn1w2q21d7xd20w";
  };

  buildInputs = [
    makeWrapper cmake qt5 pkgconfig alsaLib portaudio jack2 lame libsndfile libvorbis
  ];

  patchPhase = ''
    sed s,"/usr/local",$out, -i Makefile
  '';

  preBuild = "make lrelease";

  meta = with stdenv.lib; {
    description = "Qt-based score editor";
    homepage = http://musescore.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.vandenoever ];
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
