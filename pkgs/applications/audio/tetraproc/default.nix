{ stdenv, fetchurl, makeWrapper
, expat, fftwFloat, fontconfig, freetype, libjack2, jack2Full, libclthreads, libclxclient
, libsndfile, libxcb, xorg
}:

stdenv.mkDerivation rec {
  name = "tetraproc-${version}";
  version = "0.8.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "17y3vbm5f6h5cmh3yfxjgqz4xhfwpkla3lqfspnbm4ndlzmfpykv";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    expat libjack2 libclthreads libclxclient fftwFloat fontconfig libsndfile freetype
    libxcb xorg.libX11 xorg.libXau xorg.libXdmcp xorg.libXft xorg.libXrender
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  postInstall = ''
    # Make sure Jack is avalable in $PATH for tetraproc
    wrapProgram $out/bin/tetraproc --prefix PATH : "${jack2Full}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Converts the A-format signals from a tetrahedral Ambisonic microphone into B-format signals ready for recording";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
