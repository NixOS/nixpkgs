{
  lib,
  stdenv,
  fetchFromGitHub,
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
  airspy,
  hackrf,
  libiio,
  limesuite,
  rtl-sdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdr-j-fm";
  version = "3.20-2025-10-07";

  src = fetchFromGitHub {
    owner = "JvanKatwijk";
    repo = "sdr-j-fm";
    rev = "e348cc0a4b4b16f716f36115400dfd861b9a0bd5";
    hash = "sha256-Do2W+B4U8xxCwGRjrJNWkSpgcXG+2PXoemju5oef+jU=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    libsForQt5.qwt6_1
    fftwFloat
    libsamplerate
    portaudio
    libusb1
    libsndfile
  ];
  cmakeFlags = lib.mapAttrsToList lib.cmakeBool finalAttrs.passthru.features ++ [
    # https://github.com/JvanKatwijk/sdr-j-fm/issues/27#issuecomment-3371932903
    # https://github.com/NixOS/nixpkgs/issues/445447
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  passthru = {
    features = {
      # All of these features don't require an external dependencies, although it
      # may be implied - upstraem bundles everything they need in their repo.
      AIRSPY = true;
      SDRPLAY_V3 = true;
      HACKRF = true;
      LIME = true;
      PLUTO = true;
      RTLSDR = true;
      # Some more cmake flags are mentioned in upstream's CMakeLists.txt file
      # but they don't actually make a difference.
    }
    // featuresOverride;
    runtimeDependencies = [
      airspy
      hackrf
      libiio
      limesuite
      rtl-sdr
    ];
  };

  postInstall = ''
    # Weird default of upstream
    mv $out/linux-bin $out/bin
    mv $out/bin/fmreceiver{-3.15,}

    # Ideally, upstream's cmake files should link these libraries to the
    # executable, but it'd require a bit of work. See:
    # https://github.com/JvanKatwijk/sdr-j-fm/issues/27
    wrapProgram $out/bin/fmreceiver \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.finalPackage.passthru.runtimeDependencies}
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
