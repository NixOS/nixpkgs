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
}:

stdenv.mkDerivation rec {
  pname = "puredata";
  version = "0.54-1";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${version}.src.tar.gz";
    hash = "sha256-hcPUvTYgtAHntdWEeHoFIIKylMTE7us1g9dwnZP9BMI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    makeWrapper
  ];

  buildInputs =
    [
      fftw
      libjack2
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      portaudio
    ];

  configureFlags =
    [
      "--enable-universal"
      "--enable-fftw"
      "--enable-jack"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--enable-alsa"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--enable-portaudio"
      "--without-local-portaudio"
      "--disable-jack-framework"
      "--with-wish=${tk}/bin/wish8.6"
    ];

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${lib.makeBinPath [ tk ]}
  '';

  meta = with lib; {
    description = ''A real-time graphical programming environment for audio, video, and graphical processing'';
    homepage = "http://puredata.info";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlthome ];
    mainProgram = "pd";
    changelog = "https://msp.puredata.info/Pd_documentation/x5.htm#s1";
  };
}
