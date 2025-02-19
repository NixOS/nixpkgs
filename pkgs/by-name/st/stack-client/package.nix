{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  extra-cmake-modules,
  qt6,
  zlib,
  sqlite,
  kdePackages,
  callPackage,
}:

let
  kdsingleapplication = callPackage ./kdsingleapplication.nix { };

  libre-graph-api = stdenv.mkDerivation rec {
    pname = "libre-graph-api-cpp-qt-client";
    version = "1.0.4";

    src = fetchFromGitHub {
      owner = "owncloud";
      repo = "libre-graph-api-cpp-qt-client";
      rev = "v${version}";
      sha256 = "wbdamPi2XSLWeprrYZtBUDH1A2gdp6/5geFZv+ZqSWk=";
    };

    preConfigure = "cd client";

    nativeBuildInputs = [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qttools
    ];

    meta = with lib; {
      description = "C++ Qt client library for Libre Graph API";
      homepage = "https://github.com/owncloud/libre-graph-api-cpp-qt-client";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };
in
stdenv.mkDerivation rec {
  pname = "stack-client";
  version = "latest";

  src = fetchurl {
    url = "https://filehosting-client.transip.nl/packages/stack-source-latest.tar.gz";
    sha256 = "ac69699edb1618ef094e4b642fe72c87bf15e65026029486bef50826a746e19c";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    kdsingleapplication
    libre-graph-api
    zlib
    sqlite
    kdePackages.kcoreaddons
  ];

  meta = with lib; {
    description = "Stack Client for TransIP";
    homepage = "https://www.transip.nl/stack";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
