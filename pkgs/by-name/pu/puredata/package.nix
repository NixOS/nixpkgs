{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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
  version = "0.55-2";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-EIKX+NHdGQ346LtKSsNIeSrM9wT5ogUtk8uoybi7Wls=";
  };

  patches = [
    # expose error function used by dependents
    ./expose-error.patch

    # Fix build with GCC 15
    (fetchpatch {
      url = "https://github.com/pure-data/pure-data/commit/95e4105bc1044cbbcbbbcc369480a77c298d7475.patch";
      hash = "sha256-zFB9m8Nw80X9+a64Uft4tNRA4BHsVr8zxLqAof0jJEI=";
    })
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
    changelog = "https://msp.puredata.info/Pd_documentation/x5.htm#s1";
  };
})
