{ stdenv, fetchurl, alsaLib, cmake, libGLU, libGL, makeWrapper, qt4 }:

stdenv.mkDerivation  {
  pname = "pianobooster";
  version = "0.6.4b";

  src = fetchurl {
    url = "mirror://sourceforge/pianobooster/pianobooster-src-0.6.4b.tar.gz";
    sha256 = "1xwyap0288xcl0ihjv52vv4ijsjl0yq67scc509aia4plmlm6l35";
  };

  patches = [
    ./pianobooster-0.6.4b-cmake.patch
    ./pianobooster-0.6.4b-cmake-gcc4.7.patch
  ];

  preConfigure = "cd src";

  buildInputs = [ alsaLib cmake makeWrapper libGLU libGL qt4 ];
  NIX_LDFLAGS = "-lGL -lpthread";

  postInstall = ''
    wrapProgram $out/bin/pianobooster \
      --prefix LD_LIBRARY_PATH : ${libGL}/lib \
      --prefix LD_LIBRARY_PATH : ${libGLU}/lib
  '';

  meta = with stdenv.lib; {
    description = "A MIDI file player that teaches you how to play the piano";
    homepage = http://pianobooster.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
