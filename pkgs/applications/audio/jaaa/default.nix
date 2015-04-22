{ stdenv, fetchurl, alsaLib, libclthreads, libclxclient, libX11, libXft, libXrender, fftwFloat, freetype, fontconfig, jack2, xlibs, zita-alsa-pcmi }:

stdenv.mkDerivation rec {
  name = "jaaa-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0jyll4rkb6vja2widc340ww078rr24c6nmxbxdqvbxw409nccd01";
  };

  buildInputs = [
    alsaLib libclthreads libclxclient libX11 libXft libXrender fftwFloat jack2 zita-alsa-pcmi
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${xlibs.xproto}/include"
    "-I${libX11}/include"
    "-I${libXft}/include"
    "-I${freetype}/include"
    "-I${fontconfig}/include"
    "-I${libXrender}/include"
    "-I${xlibs.renderproto}/include"
    "-I${alsaLib}/include"
    "-I${zita-alsa-pcmi}/include"
  ];

  patchPhase = ''
    cd source/
    sed -i "s@clthreads.h@${libclthreads}/include@g" $(find . -name '*.cc')
    sed -i "s@clxclient.h@${libclxclient}/include@g" $(find . -name '*.cc')
    sed -i "s@clthreads.h@${libclthreads}/include@g" $(find . -name '*.h')
    sed -i "s@clxclient.h@${libclxclient}/include@g" $(find . -name '*.h')
  '';

  buildlPhase = ''
    make PREFIX="$out"
  '';

  installPhase = ''
    echo zita= ${zita-alsa-pcmi}
    make PREFIX="$out" install
    install -Dm644 ../README "$out/README"
  '';

  meta = with stdenv.lib; {
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/index.html;
    description = "JACK and ALSA Audio Analyser";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
