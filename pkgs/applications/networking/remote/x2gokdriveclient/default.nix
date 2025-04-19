{
  stdenv,
  lib,
  fetchurl,
  qt5,
  qtbase,
  qtx11extras,
  qttools,
  zlib,
  gnumake,
}:

stdenv.mkDerivation rec {
  pname = "x2gokdriveclient";
  version = "0.0.0.1";

  src = fetchurl {
    url = "https://code.x2go.org/releases/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "XO6McNZUEQ67TIa9AMHb0qVb5q4kHkZef6GMhpbDdvs=";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    zlib
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-warn "SHELL=/bin/bash" "SHELL=$SHELL" \
      --replace-warn "MAKEOVERRIDES" "NOMAKEOVERRIDES " \
      --replace-warn ".MAKEFLAGS" ".NOFLAGS " \
      --replace-warn "qmake" "${qtbase.dev}/bin/qmake" \
      --replace-warn "-o root -g root" ""
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc"
    "build_client"
    "build_man"
  ];

  installTargets = [
    "install_client"
    "install_man"
  ];

  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = with lib; {
    description = "Graphical NoMachine NX3 remote desktop client (KDrive client)";
    mainProgram = "x2gokdriveclient";
    homepage = "http://x2go.org/";
    maintainers = with maintainers; [ juliabru ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
