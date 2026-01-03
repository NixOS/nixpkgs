{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  cmake,
  curl,
  nasm,
  game-music-emu,
  libpng,
  SDL2,
  SDL2_mixer,
  libvpx,
  libyuv,
  zlib,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ringracers";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "KartKrewDev";
    repo = "RingRacers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iMbrbZCarMebP+ruu1JH4kwks6rR9A9CMquDUnMCUhU=";
  };

  assets = fetchzip {
    name = "${finalAttrs.pname}-${finalAttrs.version}-assets";
    url = "https://github.com/KartKrewDev/RingRacers/releases/download/v${finalAttrs.version}/Dr.Robotnik.s-Ring-Racers-v${finalAttrs.version}-Assets.zip";
    hash = "sha256-vL3Ceu6/tIOl/+TJFjntCksDdjpgLc1aNHvSx6x8/90=";
    stripRoot = false;
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    nasm
    makeBinaryWrapper
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    curl
    game-music-emu
    libpng
    SDL2
    SDL2_mixer
    libvpx
    libyuv
    zlib
  ];

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${finalAttrs.assets}"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2}/include/SDL2"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ringracers";
      exec = "ringracers";
      icon = "ringracers";
      comment = "This is Racing at the Next Level";
      desktopName = "Dr. Robotnik's Ring Racers";
      startupWMClass = ".ringracers-wrapped";
      categories = [ "Game" ];
    })
  ];

  installPhase =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      runHook preInstall

      install -Dm644 ../srb2.png $out/share/icons/hicolor/256x256/apps/ringracers.png
      install -Dm755 bin/ringracers $out/bin/ringracers

      wrapProgram $out/bin/ringracers \
        --set RINGRACERSWADDIR "${finalAttrs.assets}"

      runHook postInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r bin/ringracers.app $out/Applications/

      wrapProgram $out/Applications/ringracers.app/Contents/MacOS/ringracers \
        --set RINGRACERSWADDIR "${finalAttrs.assets}"

      mkdir -p $out/bin
      cat << EOF > "$out/bin/ringracers"
      #!${stdenv.shell}
      open -na "$out/Applications/ringracers.app" --args "\$@"
      EOF
      chmod +x $out/bin/ringracers

      runHook postInstall
    '';

  meta = {
    description = "Kart racing video game based on Sonic Robo Blast 2 (SRB2), itself based on a modified version of Doom Legacy";
    homepage = "https://kartkrew.org";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "ringracers";
  };
})
