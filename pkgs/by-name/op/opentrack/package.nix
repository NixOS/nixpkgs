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
  libxdmcp,
  libevdev,
  makeDesktopItem,
  wineWow64Packages,
  onnxruntime,
  nix-update-script,
  withWine ? stdenv.targetPlatform.isx86_64,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opentrack";
  version = "2026.1.0-unstable-2026-01-03";

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "opentrack";
    rev = "0779d3ce9da19d46919e909d0a1a252d67122db9";
    hash = "sha256-n7XCNNXgfwU4q27Q7ss9tgc2Z/tmzcRxUP4chwpPN38=";
  };

  aruco = callPackage ./aruco.nix { };

  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sdk_zip_files/XPSDK411.zip";
    hash = "sha256-zay5QrHJctllVFl+JhlyTDzH68h5UoxncEt+TpW3UgI=";
    # see license.txt inside the zip file
    meta.license = lib.licenses.free;
  };

  patches = [
    # calls `app.setDesktopFileName("opentrack");` - distros that don't wrap the binary apparently don't need this.
    ./desktop-filename.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals withWine [ wineWow64Packages.stable ];

  buildInputs = [
    finalAttrs.aruco
    eigen
    libxdmcp
    libevdev
    onnxruntime
    opencv4
    procps
    qt6.qtbase
    qt6.qttools
  ];

  cmakeFlags = [
    (lib.cmakeFeature "OPENTRACK_COMMIT" "opentrack-${finalAttrs.version}")
    (lib.cmakeBool "SDK_WINE" withWine)
    (lib.cmakeFeature "SDK_ARUCO_LIBPATH" "${finalAttrs.aruco}/lib/libaruco.a")
    (lib.cmakeFeature "SDK_XPLANE" finalAttrs.xplaneSdk.outPath)
  ];

  postInstall = ''
    install -Dt $out/share/icons/hicolor/256x256/apps ../gui/images/opentrack.png
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
