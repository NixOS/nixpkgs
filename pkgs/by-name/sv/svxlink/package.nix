{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  alsa-lib,
  speex,
  libopus,
  curl,
  gsm,
  libgcrypt,
  libgpiod_1,
  libsigcxx,
  popt,
  qt5,
  rtl-sdr,
  tcl,
  doxygen,
  groff,
  jsoncpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svxlink";
  version = "25.05.1";

  src = fetchFromGitHub {
    owner = "sm0svx";
    repo = "svxlink";
    tag = finalAttrs.version;
    hash = "sha256-OyAR/6heGX6J53p6x+ZPXY6nzSv22umMTg0ISlWcjp8=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  cmakeFlags = [
    (lib.cmakeBool "DO_INSTALL_CHOWN" false)
    (lib.cmakeFeature "RTLSDR_LIBRARIES" "${rtl-sdr}/lib/librtlsdr.so")
    (lib.cmakeFeature "RTLSDR_INCLUDE_DIRS" "${rtl-sdr}/include")
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    groff
    pkg-config
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    curl
    gsm
    jsoncpp
    libgcrypt
    libgpiod_1
    libopus
    libsigcxx
    popt
    qt5.qtbase
    rtl-sdr
    speex
    tcl
  ];

  postInstall = ''
    wrapQtApp $out/bin/qtel
  '';

  meta = {
    description = "Advanced repeater controller and EchoLink software";
    longDescription = ''
      Advanced repeater controller and EchoLink software for Linux including a
      GUI, Qtel - The Qt EchoLink client
    '';
    homepage = "https://www.svxlink.org/";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ zaninime ];
    platforms = lib.platforms.linux;
  };
})
