{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  fftwSinglePrec,
  libjack2,
  libpulseaudio,
  libvorbis,
  soundtouch,
  qt5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nootka";
  # drop patch when updating to next release
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "SeeLook";
    repo = "nootka";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-lRgFCPeIBefwsHMsE8eHLxT9GQUT0iUCyIrJz+mltp0=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib
    fftwSinglePrec
    libjack2
    libpulseaudio
    libvorbis
    soundtouch
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtgraphicaleffects
    qt5.qtquickcontrols2
    qt5.qttools
  ];

  cmakeFlags = [
    "-DCMAKE_INCLUDE_PATH=${lib.getDev libjack2}/include/jack;${lib.getDev libpulseaudio}/include/pulse"
    "-DENABLE_JACK=ON"
    "-DENABLE_PULSEAUDIO=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application for practicing playing musical scores and ear training";
    mainProgram = "nootka";
    homepage = "https://nootka.sourceforge.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = [
      lib.maintainers.mmlb
    ];
    platforms = lib.platforms.linux;
  };
})
