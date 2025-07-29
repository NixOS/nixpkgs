{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  makeDesktopItem,
  alsa-lib,
  speex,
  libopus,
  curl,
  gsm,
  libgcrypt,
  libsigcxx,
  popt,
  qtbase,
  qttools,
  wrapQtAppsHook,
  rtl-sdr,
  tcl,
  doxygen,
  groff,
  jsoncpp,
}:

let
  desktopItem = makeDesktopItem rec {
    name = "Qtel";
    exec = "qtel";
    icon = "qtel";
    desktopName = name;
    genericName = "EchoLink Client";
    categories = [
      "HamRadio"
      "Qt"
      "Network"
    ];
  };

in
stdenv.mkDerivation rec {
  pname = "svxlink";
  version = "25.05.1";

  src = fetchFromGitHub {
    owner = "sm0svx";
    repo = "svxlink";
    tag = version;
    hash = "sha256-OyAR/6heGX6J53p6x+ZPXY6nzSv22umMTg0ISlWcjp8=";
  };

  cmakeFlags = [
    "-DDO_INSTALL_CHOWN=NO"
    "-DRTLSDR_LIBRARIES=${rtl-sdr}/lib/librtlsdr.so"
    "-DRTLSDR_INCLUDE_DIRS=${rtl-sdr}/include"
    "../src"
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    groff
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    curl
    gsm
    libgcrypt
    libsigcxx
    libopus
    popt
    qtbase
    qttools
    rtl-sdr
    speex
    tcl
    jsoncpp
  ];

  postInstall = ''
    rm -rf $out/share/applications
    ln -s ${desktopItem}/share/applications $out/share/applications
    wrapQtApp $out/bin/qtel
  '';

  meta = {
    description = "Advanced repeater controller and EchoLink software";
    longDescription = ''
      Advanced repeater controller and EchoLink software for Linux including a
      GUI, Qtel - The Qt EchoLink client
    '';
    homepage = "http://www.svxlink.org/";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ zaninime ];
    platforms = lib.platforms.linux;
  };
}
