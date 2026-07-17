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
  imagemagick,
  libxdmcp,
  libevdev,
  libicns,
  llvmPackages,
  makeDesktopItem,
  wineWow64Packages,
  onnxruntime,
  nix-update-script,
  v4l-utils,
  withWine ? stdenv.targetPlatform.isx86_64,
}:
let
  inherit (stdenv.hostPlatform) isLinux isDarwin;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentrack";
  version = "2026.1.0-unstable-2026-07-14";

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "opentrack";
    rev = "b4cfbcaa30e662d7543687da9fd9eb210b38fe36";
    hash = "sha256-u0+yMWAHTfK+fa7jOx7Qqgo6lrkrYhNQe3pIXpAlLBE=";
  };

  aruco = callPackage ./aruco.nix { };

  xplaneSdk = fetchzip {
    url = "https://developer.x-plane.com/wp-content/plugins/code-sample-generation/sdk_zip_files/XPSDK411.zip";
    hash = "sha256-zay5QrHJctllVFl+JhlyTDzH68h5UoxncEt+TpW3UgI=";
    # see license.txt inside the zip file
    meta.license = lib.licenses.free;
  };

  fusion = fetchFromGitHub {
    owner = "xioTechnologies";
    repo = "Fusion";
    tag = "v1.2.11";
    hash = "sha256-9bqqP+6kfdRWIRnnP+R0lXSQs6OmZoNlbCjqiJeJjpk=";
  };

  patches = [
    # calls `app.setDesktopFileName("opentrack");` - distros that don't wrap the binary apparently don't need this.
    ./desktop-filename.patch
    # disables the upstream macOS .app artifact script
    ./remove_app_bundle_script.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals isDarwin [
    libicns
    imagemagick
  ]
  ++ lib.optionals withWine [ wineWow64Packages.stable ];

  buildInputs = [
    eigen
    libxdmcp
    onnxruntime
    opencv4
    procps
    qt6.qtbase
    qt6.qttools
  ]
  ++ lib.optionals isLinux [
    finalAttrs.aruco
    libevdev
  ]
  ++ lib.optionals isDarwin [
    qt6.qtmultimedia
  ]
  # <omp.h> is available-by-default on gcc
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_AHRSFUSION" "${finalAttrs.fusion}")
    (lib.cmakeFeature "OPENTRACK_COMMIT" "opentrack-${finalAttrs.version}")
    (lib.cmakeBool "SDK_WINE" withWine)
    (lib.cmakeFeature "SDK_XPLANE" finalAttrs.xplaneSdk.outPath)
  ]
  ++ lib.optionals isLinux [
    (lib.cmakeFeature "SDK_ARUCO_LIBPATH" "${finalAttrs.aruco}/lib/libaruco.a")
  ];

  postInstall =
    lib.optionalString isLinux ''
      install -Dt $out/share/icons/hicolor/256x256/apps ../gui/images/opentrack.png
    ''
    + lib.optionalString isDarwin ''
      mkdir -p $out/Applications
      mv $out/opentrack.app $out/Applications/

      chmod -R +w "$out/Applications/opentrack.app"

      # use upstream Info.plist for correct permissions etc.
      cp "../macosx/Info.plist" "$out/Applications/opentrack.app/Contents/"
      substituteInPlace "$out/Applications/opentrack.app/Contents/Info.plist" \
        --subst-var-by "OPENTRACK-VERSION" "${finalAttrs.version}"

      cp "../macosx/PkgInfo" "$out/Applications/opentrack.app/Contents/"
      mv "$out/Plugins" "$out/Applications/opentrack.app/Contents/MacOS/Plugins"

      # create the macOS iconset
      tmp="$(mktemp -d)"
      files=""
      for size in 16 32 64 128 256 512; do
          outfile="$tmp/opentrack_''${size}x''${size}.png"
          magick "../gui/images/opentrack.png" -filter triangle -resize "''${size}x''${size}" "$outfile"
          files="$files $outfile"
      done
      png2icns "$out/Applications/opentrack.app/Contents/Resources/opentrack.icns" $files
      rm -rf "$tmp"
    '';

  # manually wrap just the main binary
  dontWrapQtApps = true;
  qtWrapperArgs =
    lib.optionals isLinux [
      "--prefix PATH : ${lib.makeBinPath [ v4l-utils ]}"
    ]
    ++ lib.optionals isDarwin [
      "--set DYLD_LIBRARY_PATH ${placeholder "out"}/Library"
    ];
  preFixup =
    lib.optionalString isLinux ''
      wrapQtApp $out/bin/opentrack
    ''
    + lib.optionalString isDarwin ''
      wrapQtApp $out/Applications/opentrack.app/Contents/MacOS/opentrack
    '';

  desktopItems = lib.optionals isLinux [
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
    platforms = lib.platforms.unix;
  };
})
