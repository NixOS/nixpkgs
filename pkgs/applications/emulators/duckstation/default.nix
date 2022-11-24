{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, curl
, extra-cmake-modules
, libXrandr
, libpulseaudio
, makeDesktopItem
, mesa # for libgbm
, ninja
, pkg-config
, qtbase
, qtsvg
, qttools
, vulkan-loader
, wayland
, wrapQtAppsHook
, enableWayland ? true
}:

stdenv.mkDerivation {
  pname = "duckstation";
  version = "unstable-2022-11-18";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = "duckstation";
    rev = "8d7aea5e19859ed483699cc4a5dbd47165c7be8b";
    sha256 = "sha256-92Wn1ZEEZszmVK/KrJqjDuQf/lyD8/VScfTI/St5dY4=";
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
  ]
  ++ lib.optionals enableWayland [ wayland ];

  cmakeFlags = [
    "-DUSE_DRMKMS=ON"
  ]
  ++ lib.optionals enableWayland [ "-DUSE_WAYLAND=ON" ];

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

  # Libpulseaudio fixes https://github.com/NixOS/nixpkgs/issues/171173
  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
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
