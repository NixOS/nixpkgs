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
, makeDesktopItem
, mesa # for libgbm
, ninja
, pkg-config
, qtbase
, qtsvg
, qttools
, qtwayland
, vulkan-loader
, wayland
, wrapQtAppsHook
, enableWayland ? true
}:

stdenv.mkDerivation {
  pname = "duckstation";
  version = "unstable-2023-09-30";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = "duckstation";
    rev = "d5608bf12df7a7e03750cb94a08a3d7999034ae2";
    hash = "sha256-ktfZgacjkN6GQb1vLmyTZMr8QmmH12qAvFSIBTjgRSs=";
  };

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
    mesa
    qtbase
    qtsvg
    vulkan-loader
  ]
  ++ lib.optionals enableWayland [
    qtwayland
    wayland
  ]
  ++ cubeb.passthru.backendLibs;

  cmakeFlags = [
    "-DUSE_DRMKMS=ON"
    "-DBUILD_TESTS=ON"
  ]
  ++ lib.optionals enableWayland [ "-DUSE_WAYLAND=ON" ];

  postPatch = ''
      substituteInPlace src/CMakeLists.txt \
      --replace 'add_subdirectory(common-tests EXCLUDE_FROM_ALL)' 'add_subdirectory(common-tests)'
  '';

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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-qt $out/bin/

    install -Dm644 bin/resources/images/duck.png $out/share/pixmaps/duckstation.png

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bin/common-tests
    runHook postCheck
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ vulkan-loader ] ++ cubeb.passthru.backendLibs)}"
  ];

  meta = with lib; {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    license = licenses.gpl3Only;
    mainProgram = "duckstation-qt";
    maintainers = with maintainers; [ guibou AndersonTorres ];
    platforms = platforms.linux;
  };
}
