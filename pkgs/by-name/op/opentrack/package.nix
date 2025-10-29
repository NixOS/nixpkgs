{
  stdenv,
  lib,
  callPackage,
  fetchzip,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  copyDesktopItems,
  qt5,
  opencv4,
  procps,
  eigen,
  libXdmcp,
  libevdev,
  makeDesktopItem,
  fetchpatch,
  wineWowPackages,
  onnxruntime,
  withWine ? stdenv.targetPlatform.isx86_64,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opentrack";
  version = "2023.3.0";

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "opentrack";
    tag = "opentrack-${finalAttrs.version}";
    hash = "sha256-C0jLS55DcLJh/e5yM8kLG7fhhKvBNllv5HkfCWRIfc4=";
  };

  patches = [
    # https://github.com/opentrack/opentrack/pull/1754
    (fetchpatch {
      url = "https://github.com/opentrack/opentrack/commit/d501d7e0b237ed0c305525788b423d842ffa356d.patch";
      hash = "sha256-XMGHV78vt/Xn3hS+4V//pqtsdBQCfJPjIXxfwtdXX+Q=";
    })
  ];

  aruco = callPackage ./aruco.nix { };

  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sdk_zip_files/XPSDK401.zip";
    hash = "sha256-tUT9yV1949QVr5VebU/7esg7wwWkyak2TSA/kQSrbeo=";
    # see license.txt inside the zip file
    meta.license = lib.licenses.free;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    qt5.wrapQtAppsHook
  ]
  ++ lib.optionals withWine [ wineWowPackages.stable ];

  buildInputs = [
    finalAttrs.aruco
    eigen
    libXdmcp
    libevdev
    onnxruntime
    opencv4
    procps
    qt5.qtbase
    qt5.qttools
  ];

  cmakeFlags = [
    (lib.cmakeBool "SDK_WINE" withWine)
    (lib.cmakeFeature "SDK_ARUCO_LIBPATH" "${finalAttrs.aruco}/lib/libaruco.a")
    (lib.cmakeFeature "SDK_XPLANE" finalAttrs.xplaneSdk.outPath)
  ];

  postInstall = ''
    install -Dt $out/share/icons/hicolor/256x256 $src/gui/images/opentrack.png
  '';

  # manually wrap just the main binary
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/opentrack
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "opentrack";
      exec = "opentrack";
      icon = "opentrack";
      desktopName = "opentrack";
      genericName = "Head tracking software";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    homepage = "https://github.com/opentrack/opentrack";
    description = "Head tracking software for MS Windows, Linux, and Apple OSX";
    mainProgram = "opentrack";
    changelog = "https://github.com/opentrack/opentrack/releases";
    license = lib.licenses.isc;
    maintainers = [
      lib.maintainers.nekowinston
      lib.maintainers.zaninime
    ];
    platforms = lib.platforms.linux;
  };
})
