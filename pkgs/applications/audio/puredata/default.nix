{ lib, stdenv, fetchurl, autoreconfHook, gettext, makeWrapper
, alsa-lib, libjack2, tk, fftw
}:

stdenv.mkDerivation rec {
  pname = "puredata";
  version = "0.52-1";

  src = fetchurl {
    url = "https://msp.puredata.info/Software/pd-${version}.src.tar.gz";
    sha256 = "sha256-e9BKGM84MtiBpY/0XI6tAAzwkOd9rlYVXrI1n/ZPmyk=";
  };

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper ];

  buildInputs = [ alsa-lib libjack2 fftw ];

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
