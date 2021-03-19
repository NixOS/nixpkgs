{ lib, stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsaLib, libjack2, tk, fftw
}:

stdenv.mkDerivation  rec {
  pname = "puredata";
  version = "0.51-4";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    sha256 = "sha256-UlkfGDFunyRxyiHD1rQcVjNuBhXsQKCTIy6VzCML/ME=";
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

  meta = with lib; {
    description = ''A real-time graphical programming environment for
                    audio, video, and graphical processing'';
    homepage = "http://puredata.info";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
