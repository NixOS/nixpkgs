{ stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsaLib, libjack2, tk, fftw
}:

stdenv.mkDerivation  rec {
  name = "puredata-${version}";
  version = "0.48-2";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    sha256 = "0p86hncgzkrl437v2wch2fg9iyn6mnrgbn811sh9pwmrjj2f06v8";
  };

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper ];

  buildInputs = [ alsaLib libjack2 fftw ];

  configureFlags = [
    "--enable-alsa"
    "--enable-jack"
    "--enable-fftw"
    "--disable-portaudio"
  ];

  # https://github.com/pure-data/pure-data/issues/188
  # --disable-oss

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
