{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, makeDesktopItem
, curl
, extra-cmake-modules
, libevdev
, libpulseaudio
, libXrandr
, mesa # for libgbm
, ninja
, pkg-config
, qtbase
, qttools
, vulkan-loader
#, wayland # Wayland doesn't work correctly this version
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "duckstation";
  version = "unstable-2022-07-08";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = pname;
    rev = "82965f741e81e4d2f7e1b2abdc011e1f266bfe7f";
    sha256 = "sha256-D8Ps/EQRcHLsps/KEUs56koeioOdE/GPA0QJSrbSdYs=";
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
    libevdev
    libpulseaudio
    libXrandr
    mesa
    qtbase
    vulkan-loader
    #wayland
  ];

  cmakeFlags = [
    "-DUSE_DRMKMS=ON"
    #"-DUSE_WAYLAND=ON"
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-qt $out/bin/

    install -Dm644 ../extras/icons/icon-256px.png $out/share/pixmaps/duckstation.png

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
