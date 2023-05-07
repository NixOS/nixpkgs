{ lib
, stdenv
, fetchurl
, autoreconfHook
, gettext
, makeWrapper
, alsa-lib
, libjack2
, tk
, fftw
, portaudio
}:

stdenv.mkDerivation rec {
  pname = "puredata";
  version = "0.50-2";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    sha256 = "0dz6r6jy0zfs1xy1xspnrxxks8kddi9c7pxz4vpg2ygwv83ghpg5";
  };

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper ];

  buildInputs = [
    fftw
    libjack2
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    portaudio
  ];

  configureFlags = [
    "--enable-universal"
    "--enable-fftw"
    "--enable-jack"
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-alsa"
  ] ++ lib.optionals stdenv.isDarwin [
    "--enable-portaudio"
    "--without-local-portaudio"
    "--disable-jack-framework"
    "--with-wish=${tk}/bin/wish8.6"
  ];

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${lib.makeBinPath [ tk ]}
  '';

  meta = with lib; {
    description = ''A real-time graphical programming environment for
                    audio, video, and graphical processing'';
    homepage = "http://puredata.info";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.goibhniu ];
    mainProgram = "pd";
  };
}
