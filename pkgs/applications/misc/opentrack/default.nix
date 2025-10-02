{
  pkgs,
  mkDerivation,
  lib,
  callPackage,
  fetchzip,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  copyDesktopItems,
  qtbase,
  qttools,
  opencv4,
  procps,
  eigen,
  libXdmcp,
  libevdev,
  makeDesktopItem,
  fetchurl,
  fetchpatch,
  wineWowPackages,
  onnxruntime,
}:
let
  version = "2023.3.0";

  aruco = callPackage ./aruco.nix { };

  # license.txt inside the zip file is MIT
  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sdk_zip_files/XPSDK401.zip";
    hash = "sha256-tUT9yV1949QVr5VebU/7esg7wwWkyak2TSA/kQSrbeo=";
  };
in
mkDerivation {
  pname = "opentrack";
  inherit version;

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "opentrack";
    rev = "opentrack-${version}";
    hash = "sha256-C0jLS55DcLJh/e5yM8kLG7fhhKvBNllv5HkfCWRIfc4=";
  };

  patches = [
    # https://github.com/opentrack/opentrack/pull/1754
    (fetchpatch {
      url = "https://github.com/opentrack/opentrack/commit/d501d7e0b237ed0c305525788b423d842ffa356d.patch";
      hash = "sha256-XMGHV78vt/Xn3hS+4V//pqtsdBQCfJPjIXxfwtdXX+Q=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    copyDesktopItems
  ];
  buildInputs = [
    qtbase
    qttools
    opencv4
    procps
    eigen
    libXdmcp
    libevdev
    aruco
    onnxruntime
  ]
  ++ lib.optionals pkgs.stdenv.targetPlatform.isx86_64 [ wineWowPackages.stable ];

  env.NIX_CFLAGS_COMPILE = "-Wall -Wextra -Wpedantic -ffast-math -O3";
  dontWrapQtApps = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSDK_ARUCO_LIBPATH=${aruco}/lib/libaruco.a"
    "-DSDK_XPLANE=${xplaneSdk}"
  ]
  ++ lib.optionals pkgs.stdenv.targetPlatform.isx86_64 [ "-DSDK_WINE=ON" ];

  postInstall = ''
    wrapQtApp $out/bin/opentrack
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "opentrack";
      exec = "opentrack";
      icon = fetchurl {
        url = "https://github.com/opentrack/opentrack/raw/opentrack-${version}/gui/images/opentrack.png";
        hash = "sha256-9k3jToEpdW14ErbNGHM4c0x/LH7k14RmtvY4dOYnITQ=";
      };
      desktopName = name;
      genericName = "Head tracking software";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    homepage = "https://github.com/opentrack/opentrack";
    description = "Head tracking software for MS Windows, Linux, and Apple OSX";
    mainProgram = "opentrack";
    changelog = "https://github.com/opentrack/opentrack/releases/tag/${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ zaninime ];
  };
}
