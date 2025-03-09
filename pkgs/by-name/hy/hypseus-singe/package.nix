{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  zlib,
  libvorbis,
  libzip,
  libmpeg2,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypseus-singe";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "DirtBagXon";
    repo = "hypseus-singe";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-hLl+/tJrBXo6m/cJxmn2bSLXcNLM8B6SKrM702Z8K8E=";
  };

  patches = [ ./use-shared-mpeg2.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    zlib
    libvorbis
    libzip
    libmpeg2
    bash
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL2_ttf}/include/SDL2"
    "-I${lib.getDev SDL2_image}/include/SDL2"
  ];

  preConfigure = ''
    cd src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 hypseus $out/bin/hypseus.bin
    cd ../..
    install -Dm755 scripts/run.sh $out/bin/hypseus
    install -Dm755 scripts/singe.sh $out/bin/singe

    substituteInPlace $out/bin/{hypseus,singe} \
        --replace-fail "/bin/cat" "cat" \
        --replace-fail hypseus.bin $out/bin/hypseus.bin

    runHook postInstall
  '';

  meta = {
    description = "Laserdisc game emulator, the SDL2 version of Daphne and Singe";
    homepage = "https://github.com/DirtBagXon/hypseus-singe";
    license = lib.licenses.gpl3Only;
    mainProgram = "hypseus";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
