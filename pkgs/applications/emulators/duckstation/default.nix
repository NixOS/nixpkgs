{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, cubeb
, curl
, extra-cmake-modules
, libXrandr
, libbacktrace
, makeDesktopItem
, ninja
, pkg-config
, qtbase
, qtsvg
, qttools
, qtwayland
, substituteAll
, vulkan-loader
, wayland
, wrapQtAppsHook
, enableWayland ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duckstation";
  version = "unstable-2023-12-04";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = "duckstation";
    rev = "1e0dbe34045f5954bde24bb6cd8a56384e0957b9";
    hash = "sha256-J0jKYVcBzhhaLCToDoXX49Nx9Hi2BRSBzMvb1zf8q2M=";
  };

  patches = [
    # Tests are not built by default
    ./001-fix-test-inclusion.diff
    # Patching yet another script that fills data based on git commands...
    (substituteAll {
      src = ./002-hardcode-vars.diff;
      gitHash = finalAttrs.src.rev;
      gitBranch = "master";
      gitTag = "0.1-6141-g1e0dbe34";
      gitDate = "2023-12-04T14:15:49+10:00";
    })
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    qttools
    wrapQtAppsHook
  ]
  ++ lib.optionals enableWayland [
    extra-cmake-modules
  ];

  buildInputs = [
    SDL2
    curl
    libXrandr
    libbacktrace
    qtbase
    qtsvg
    vulkan-loader
  ]
  ++ lib.optionals enableWayland [
    qtwayland
    wayland
  ]
  ++ cubeb.passthru.backendLibs;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
    (lib.cmakeBool "ENABLE_WAYLAND" enableWayland)
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "duckstation-qt";
      desktopName = "DuckStation";
      genericName = "PlayStation 1 Emulator";
      icon = "duckstation";
      tryExec = "duckstation-qt";
      exec = "duckstation-qt %f";
      comment = "Fast PlayStation 1 emulator";
      categories = [ "Game" "Emulator" "Qt" ];
      type = "Application";
    })
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bin/common-tests
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-qt $out/bin/

    install -Dm644 bin/resources/images/duck.png $out/share/pixmaps/duckstation.png

    runHook postInstall
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ vulkan-loader ] ++ cubeb.passthru.backendLibs)}"
  ];

  meta = {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    license = lib.licenses.gpl3Only;
    mainProgram = "duckstation-qt";
    maintainers = with lib.maintainers; [ guibou AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
