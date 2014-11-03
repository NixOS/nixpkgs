{ stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsaLib, jack2, tk
}:

stdenv.mkDerivation  rec {
  name = "puredata-${version}";
  version = "0.45-4";

  src = fetchurl {
    url = "mirror://sourceforge/pure-data/pd-${version}.src.tar.gz";
    sha256 = "1ls2ap5yi2zxvmr247621g4jx0hhfds4j5704a050bn2n3l0va2p";
  };

  patchPhase = ''
    rm portaudio/configure.in
  '';

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper ];

  buildInputs = [ alsaLib jack2 ];

  configureFlags = ''
    --enable-alsa
    --enable-jack
    --disable-portaudio
  '';

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${tk}/bin
  '';

  meta = with stdenv.lib; {
    description = ''A real-time graphical programming environment for
                    audio, video, and graphical processing'';
    homepage = http://puredata.info;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
