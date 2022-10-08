{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, makeDesktopItem
, curl
, extra-cmake-modules
, libpulseaudio
, libXrandr
, mesa # for libgbm
, ninja
, pkg-config
, qtbase
, qtsvg
, qttools
, vulkan-loader
, wayland
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "duckstation";
  version = "unstable-2022-08-22";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = pname;
    rev = "4f2da4213d1d2c69417392d15b27bb123ee9d297";
    sha256 = "sha256-VJeKbJ40ZErlu/6RETvk0KDSc9T7ssBrLDecNczQlXU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    copyDesktopItems
    ninja
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    curl
    libpulseaudio
    libXrandr
    mesa
    qtbase
    qtsvg
    vulkan-loader
    wayland
  ];

  cmakeFlags = [
    "-DUSE_DRMKMS=ON"
    "-DUSE_WAYLAND=ON"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "DuckStation";
      desktopName = "JamesDSP";
      genericName = "PlayStation 1 Emulator";
      icon = "duckstation";
      tryExec = "duckstation-qt";
      exec = "duckstation-qt %f";
      comment = "Fast PlayStation 1 emulator";
      categories = [ "Game" "Emulator" "Qt" ];
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

  # Libpulseaudio fixes https://github.com/NixOS/nixpkgs/issues/171173
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio vulkan-loader ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ guibou AndersonTorres ];
    platforms = platforms.linux;
  };
}
