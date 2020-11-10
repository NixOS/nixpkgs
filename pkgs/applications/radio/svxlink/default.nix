{ stdenv, cmake, pkgconfig, fetchFromGitHub, makeDesktopItem, alsaLib, speex
, libopus, curl, gsm, libgcrypt, libsigcxx, popt, qtbase, qttools
, wrapQtAppsHook, rtl-sdr, tcl, doxygen, groff }:

let
  desktopItem = makeDesktopItem rec {
    name = "Qtel";
    exec = "qtel";
    icon = "qtel";
    desktopName = name;
    genericName = "EchoLink Client";
    categories = "HamRadio;Qt;Network;";
  };

in stdenv.mkDerivation rec {
  pname = "svxlink";
  version = "19.09.1";

  src = fetchFromGitHub {
    owner = "sm0svx";
    repo = pname;
    rev = version;
    sha256 = "0xmbac821w9kl7imlz0mra19mlhi0rlpbyyay26w1y7h98j4g4yp";
  };

  cmakeFlags = [
    "-DDO_INSTALL_CHOWN=NO"
    "-DRTLSDR_LIBRARIES=${rtl-sdr}/lib/librtlsdr.so"
    "-DRTLSDR_INCLUDE_DIRS=${rtl-sdr}/include"
    "../src"
  ];
  enableParallelBuilding = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [ cmake pkgconfig doxygen groff wrapQtAppsHook ];

  buildInputs = [
    alsaLib
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

  meta = with stdenv.lib; {
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
