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
  zlib,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srb2kart";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "STJr";
    repo = "Kart-Public";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5sIHdeenWZjczyYM2q+F8Y1SyLqL+y77yxYDUM3dVA0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  assets = fetchzip {
    name = "srb2kart-data";
    url = "https://github.com/STJr/Kart-Public/releases/download/v${finalAttrs.version}/AssetsLinuxOnly.zip";
    hash = "sha256-yaVdsQUnyobjSbmemeBEyu35GeZCX1ylTRcjcbDuIu4=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
    nasm
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    curl
    game-music-emu
    libpng
    SDL2
    SDL2_mixer
    zlib
  ];

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${finalAttrs.assets}"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2}/include/SDL2"
  ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "Sonic Robo Blast 2 Kart";
      exec = "srb2kart";
      icon = "srb2kart";
      comment = "Kart racing mod based on SRB2";
      desktopName = name;
      genericName = name;
      startupWMClass = ".srb2kart-wrapped";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ../srb2.png $out/share/pixmaps/srb2kart.png
    install -Dm644 ../srb2.png $out/share/icons/srb2kart.png
    install -Dm755 bin/srb2kart $out/bin/srb2kart

    wrapProgram $out/bin/srb2kart \
      --set-default SRB2WADDIR ${finalAttrs.assets}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Classic styled kart racer";
    homepage = "https://mb.srb2.org/threads/srb2kart.25868/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "srb2kart";
  };
})
