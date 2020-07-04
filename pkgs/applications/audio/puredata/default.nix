{ stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsaLib, libjack2, tk, fftw
}:

stdenv.mkDerivation  rec {
  pname = "puredata";
  version = "0.50-2";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    sha256 = "0dz6r6jy0zfs1xy1xspnrxxks8kddi9c7pxz4vpg2ygwv83ghpg5";
  };

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper ];

  buildInputs = [ alsaLib libjack2 fftw ];

  configureFlags = [
    "--enable-alsa"
    "--enable-jack"
    "--enable-fftw"
    "--disable-portaudio"
    "--disable-oss"
  ];

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${tk}/bin
  '';

  meta = with stdenv.lib; {
    description = ''A real-time graphical programming environment for
                    audio, video, and graphical processing'';
    homepage = "http://puredata.info";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
