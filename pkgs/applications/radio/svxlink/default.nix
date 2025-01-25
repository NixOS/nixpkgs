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
  version = "19.09.2";

  src = fetchFromGitHub {
    owner = "sm0svx";
    repo = pname;
    rev = version;
    sha256 = "sha256-riyFEuEmJ7+jYT3UoTTsMUwFdO3y5mjo4z0fcC3O8gY=";
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
  ];

  postInstall = ''
    rm -f $out/share/applications/*
    cp -v ${desktopItem}/share/applications/* $out/share/applications
    mv $out/share/icons/link.xpm $out/share/icons/qtel.xpm

    wrapQtApp $out/bin/qtel
  '';

  meta = with lib; {
    description = "Advanced repeater controller and EchoLink software";
    longDescription = ''
      Advanced repeater controller and EchoLink software for Linux including a
      GUI, Qtel - The Qt EchoLink client
    '';
    homepage = "http://www.svxlink.org/";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ zaninime ];
    platforms = platforms.linux;
  };
}
