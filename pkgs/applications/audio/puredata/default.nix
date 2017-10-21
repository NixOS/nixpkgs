{ stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsaLib, libjack2, tk
}:

stdenv.mkDerivation  rec {
  name = "puredata-${version}";
  version = "0.47-1";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    sha256 = "0k5s949kqd7yw97h3m8z81bjz32bis9m4ih8df1z0ymipnafca67";
  };

  patchPhase = ''
    rm portaudio/configure.in
  '';

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper ];

  buildInputs = [ alsaLib libjack2 ];

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
