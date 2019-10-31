{ stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsaLib, libjack2, tk, fftw
}:

stdenv.mkDerivation  rec {
  pname = "puredata";
  version = "0.49-0";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    sha256 = "18rzqbpgnnvyslap7k0ly87aw1bbxkb0rk5agpr423ibs9slxq6j";
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
    homepage = http://puredata.info;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
