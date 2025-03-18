{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wrapQtAppsHook,
  pkg-config,
  qtbase,
  qwt,
  fftwFloat,
  libsamplerate,
  portaudio,
  libusb1,
  libsndfile,
  featuresOverride ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdr-j-fm";
  # The stable release doen't include the commit the came after 3.16 which
  # added support for cmake options instead of using cmake set() commands. See
  # also: https://github.com/JvanKatwijk/sdr-j-fm/pull/25
  version = "3.16-unstable-2023-12-07";

  src = fetchFromGitHub {
    owner = "JvanKatwijk";
    repo = "sdr-j-fm";
    rev = "8e3a67f8fbf72dd6968cbeb2e3d7d513fd107c71";
    hash = "sha256-l9WqfhDp2V01lhleYZqRpmyL1Ww+tJj10bjkMMlvyA0=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qtbase
    qwt
    fftwFloat
    libsamplerate
    portaudio
    libusb1
    libsndfile
  ];
  cmakeFlags = lib.mapAttrsToList lib.cmakeBool finalAttrs.passthru.features;

  passthru = {
    features = {
      # All of these features don't require an external depencies, althought it
      # may be implied - upstraem bundles everything they need in their repo.
      AIRSPY =     true;
      SDRPLAY =    true;
      SDRPLAY_V3 = true;
      HACKRF =     true;
      PLUTO =      true;
      # Some more cmake flags are mentioned in upstream's CMakeLists.txt file
      # but they don't actually make a difference.
    } // featuresOverride;
  };

  postInstall = ''
    # Weird default of upstream
    mv $out/linux-bin $out/bin
  '';

  meta = with lib; {
    description = "SDR based FM radio receiver software";
    homepage = "https://github.com/JvanKatwijk/sdr-j-fm";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ doronbehar ];
    # Upstream doesn't find libusb1 on Darwin. Upstream probably doesn't
    # support it officially.
    platforms = platforms.linux;
  };
})
