{ lib, stdenv, fetchurl, makeWrapper
, expat, fftwFloat, fontconfig, freetype, libjack2, jack2, libclthreads, libclxclient
, libsndfile, libxcb, xorg
}:

stdenv.mkDerivation rec {
  pname = "tetraproc";
  version = "0.8.6";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "02155ljfwgvfgq9z258fb4z7jrz7qx022d054fj5gr0v007cv0r7";
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
    wrapProgram $out/bin/tetraproc --prefix PATH : "${jack2}/bin"
  '';

  meta = with lib; {
    description = "Converts the A-format signals from a tetrahedral Ambisonic microphone into B-format signals ready for recording";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
