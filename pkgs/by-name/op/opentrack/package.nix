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
  qt6,
  opencv4,
  procps,
  eigen,
  libXdmcp,
  libevdev,
  makeDesktopItem,
  wineWowPackages,
  onnxruntime,
  nix-update-script,
  withWine ? stdenv.targetPlatform.isx86_64,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opentrack";
  version = "2024.1.1-unstable-2025-12-16";

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "opentrack";
    rev = "32273718b42b80973671ed1883ff74645cf83ca0";
    hash = "sha256-bNhMtxPL0VxpSP7/rYs5dCAAR1EKuBwfDggHo0OZOnA=";
  };

  aruco = callPackage ./aruco.nix { };

  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sdk_zip_files/XPSDK411.zip";
    hash = "sha256-zay5QrHJctllVFl+JhlyTDzH68h5UoxncEt+TpW3UgI=";
    # see license.txt inside the zip file
    meta.license = lib.licenses.free;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    qt6.wrapQtAppsHook
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
    qt6.qtbase
    qt6.qttools
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex"
      "^opentrack-(.+)"
    ];
  };

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
