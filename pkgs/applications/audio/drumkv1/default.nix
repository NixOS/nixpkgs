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

stdenv.mkDerivation rec {
  pname = "drumkv1";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/drumkv1-${version}.tar.gz";
    hash = "sha256-WcWhq1Li9dfj0piyW6F0mdfzcK+nvk5Rtl8pQZTYyt8=";
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

  meta = with lib; {
    description = "Old-school drum-kit sampler synthesizer with stereo fx";
    mainProgram = "drumkv1_jack";
    homepage = "http://drumkv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.theredstonedev ];
  };
}
