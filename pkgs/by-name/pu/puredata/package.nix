{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  makeWrapper,
  alsa-lib,
  libjack2,
  tk,
  fftw,
  portaudio,
  portmidi,
}:

stdenv.mkDerivation rec {
  pname = "puredata";
  version = "0.55-2";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    hash = "sha256-EIKX+NHdGQ346LtKSsNIeSrM9wT5ogUtk8uoybi7Wls=";
  };

  patches = [
    # expose error function used by dependents
    ./expose-error.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    makeWrapper
  ];

  buildInputs = [
    fftw
    libjack2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    portmidi
    portaudio
  ];

  configureFlags = [
    "--enable-fftw"
    "--enable-jack"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-alsa"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--enable-portaudio"
    "--enable-portmidi"
    "--without-local-portaudio"
    "--without-local-portmidi"
    "--disable-jack-framework"
    "--with-wish=${tk}/bin/wish8.6"
  ];

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${lib.makeBinPath [ tk ]}
    wrapProgram $out/bin/pd-gui --prefix PATH : ${lib.makeBinPath [ tk ]}
  '';

  meta = with lib; {
    description = ''Real-time graphical programming environment for audio, video, and graphical processing'';
    homepage = "http://puredata.info";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlthome ];
    mainProgram = "pd";
    changelog = "https://msp.puredata.info/Pd_documentation/x5.htm#s1";
  };
}
