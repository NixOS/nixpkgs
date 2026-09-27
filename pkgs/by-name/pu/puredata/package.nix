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

stdenv.mkDerivation (finalAttrs: {
  pname = "puredata";
  version = "0.56-5";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-GOynTqtEnb2ND8kY8frVeMhjKscwYJ1/I9RLsmEpH0E=";
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

  meta = {
    description = "Real-time graphical programming environment for audio, video, and graphical processing";
    homepage = "http://puredata.info";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ carlthome ];
    mainProgram = "pd";
    changelog = "https://msp.ucsd.edu/Pd_documentation/5.current.status.htm#${finalAttrs.version}";
  };
})
