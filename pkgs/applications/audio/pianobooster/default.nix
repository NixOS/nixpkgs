{ stdenv, fetchurl, alsaLib, cmake, libGLU_combined, makeWrapper, qt4 }:

stdenv.mkDerivation  rec {
  name = "pianobooster-${version}";
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

  buildInputs = [ alsaLib cmake makeWrapper libGLU_combined qt4 ];

  postInstall = ''
    wrapProgram $out/bin/pianobooster \
      --prefix LD_LIBRARY_PATH : ${libGLU_combined}/lib
  '';

  meta = with stdenv.lib; {
    description = "A MIDI file player that teaches you how to play the piano";
    homepage = http://pianobooster.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
