{ lib
, mkDerivation
, fetchFromGitHub
, SDL2
, cmake
, curl
, extra-cmake-modules
, gtk3
, libevdev
, libpulseaudio
, mesa
, ninja
, pkg-config
, qtbase
, qttools
, sndio
, vulkan-loader
, wayland
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "duckstation";
  version = "0.pre+date=2022-01-18";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = pname;
    rev = "51041e47f70123eda41d999701f5651830a0a95e";
    sha256 = "sha256-nlF6ctDU8KCK7MN2pniPLLqUbPUygX9rl0hjzVQ+mPo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ninja
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    curl
    gtk3
    libevdev
    libpulseaudio
    mesa
    qtbase
    sndio
    vulkan-loader
    wayland
  ];

  cmakeFlags = [
    "-DUSE_DRMKMS=ON"
    "-DUSE_WAYLAND=ON"
  ];

  postPatch = ''
    substituteInPlace extras/linux-desktop-files/duckstation-qt.desktop \
      --replace "duckstation-qt" "duckstation" \
      --replace "TryExec=duckstation" "tryExec=duckstation-qt" \
      --replace "Exec=duckstation" "Exec=duckstation-qt"
    substituteInPlace extras/linux-desktop-files/duckstation-nogui.desktop \
      --replace "duckstation-nogui" "duckstation" \
      --replace "TryExec=duckstation" "tryExec=duckstation-nogui" \
      --replace "Exec=duckstation" "Exec=duckstation-nogui"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/pixmaps $out/share/applications
    rm bin/common-tests

    cp -r bin $out/share/duckstation
    ln -s $out/share/duckstation/duckstation-{qt,nogui} $out/bin/

    cp ../extras/icons/icon-256px.png $out/share/pixmaps/duckstation.png
    cp ../extras/linux-desktop-files/* $out/share/applications/

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./bin/common-tests
    runHook postCheck
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  meta = with lib; {
    homepage = "https://github.com/stenzek/duckstation";
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ guibou AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: default sound backend (cubeb) does not work, but SDL does. Strangely,
# switching to cubeb while a game is running makes it work.
