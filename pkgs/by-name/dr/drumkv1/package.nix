{
  stdenv,
  lib,
  pkg-config,
  fetchurl,
  cmake,
  libjack2,
  alsa-lib,
  libsndfile,
  liblo,
  lv2,
  qt6,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drumkv1";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/drumkv1-${finalAttrs.version}.tar.gz";
    hash = "sha256-Z9F9lbLSAJRlVh7tnSMNTlK7FiZhhlVfeHPlbbVuWXk=";
  };

  buildInputs = [
    libjack2
    alsa-lib
    libsndfile
    liblo
    lv2
    xorg.libX11
    qt6.qtbase
    qt6.qtwayland
    qt6.qtsvg
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    # disable experimental feature "LV2 port change request"
    "-DCONFIG_LV2_PORT_CHANGE_REQUEST=false"
    # override libdir -- temporary until upstream fixes CMakeLists.txt
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    description = "Old-school drum-kit sampler synthesizer with stereo fx";
    mainProgram = "drumkv1_jack";
    homepage = "http://drumkv1.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ theredstonedev ];
  };
})
