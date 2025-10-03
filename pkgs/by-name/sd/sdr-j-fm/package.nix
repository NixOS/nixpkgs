{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  qt5,
  libsForQt5,
  fftwFloat,
  libsamplerate,
  portaudio,
  libusb1,
  libsndfile,
  featuresOverride ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdr-j-fm";
  version = "3.20";

  src = fetchFromGitHub {
    owner = "JvanKatwijk";
    repo = "sdr-j-fm";
    tag = finalAttrs.version;
    hash = "sha256-qNSmBVY1n5+DR9k1d+nY11gBrYS7Ah774R2FMgCR4ks=";
  };

  patches = [
    # Fix linking error, https://github.com/JvanKatwijk/sdr-j-fm/pull/26
    (fetchpatch {
      url = "https://github.com/JvanKatwijk/sdr-j-fm/pull/26/commits/b336b5175a267347e037adb333669e571f7bde01.patch";
      hash = "sha256-xYNR6XZVSKKk+s/DQJFGaSGc2U+P1AWFIeiRnGfpZX8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt5.qtbase
    libsForQt5.qwt6_1
    fftwFloat
    libsamplerate
    portaudio
    libusb1
    libsndfile
  ];
  cmakeFlags = lib.mapAttrsToList lib.cmakeBool finalAttrs.passthru.features;

  passthru = {
    features = {
      # All of these features don't require an external dependencies, although it
      # may be implied - upstraem bundles everything they need in their repo.
      AIRSPY = true;
      SDRPLAY = true;
      SDRPLAY_V3 = true;
      HACKRF = true;
      LIME = true;
      PLUTO = true;
      RTLSDR = true;
      # Some more cmake flags are mentioned in upstream's CMakeLists.txt file
      # but they don't actually make a difference.
    }
    // featuresOverride;
  };

  postInstall = ''
    # Weird default of upstream
    mv $out/linux-bin $out/bin
    mv $out/bin/fmreceiver{-3.15,}
  '';

  meta = {
    description = "SDR based FM radio receiver software";
    homepage = "https://github.com/JvanKatwijk/sdr-j-fm";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ doronbehar ];
    # Upstream doesn't find libusb1 on Darwin. Upstream probably doesn't
    # support it officially.
    platforms = lib.platforms.linux;
    mainProgram = "fmreceiver";
  };
})
