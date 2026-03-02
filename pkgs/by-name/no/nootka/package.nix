{
  lib,
  stdenv,
  fetchurl,
  cmake,
  alsa-lib,
  fftwSinglePrec,
  libjack2,
  libpulseaudio,
  libvorbis,
  soundtouch,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nootka";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/nootka/nootka-${finalAttrs.version}-source.tar.bz2";
    hash = "sha256-ZHdyLZ3+TCpQ77tcNuDlN2124qLDZu9DdH5x7RI1HIs=";
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

  meta = {
    description = "Application for practicing playing musical scores and ear training";
    mainProgram = "nootka";
    homepage = "https://nootka.sourceforge.io/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mmlb
    ];
    platforms = lib.platforms.linux;
  };
})
