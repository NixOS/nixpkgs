{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  makeWrapper,
  pkg-config,

  bash,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  libmpeg2,
  libvorbis,
  libzip,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypseus-singe";
  version = "2.11.6";

  src = fetchFromGitHub {
    owner = "DirtBagXon";
    repo = "hypseus-singe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fSqlpzA2NUY1Sk+OTj9SmeRfQ+nqY9iAa3vTwr4OV9Q=";
  };

  patches = [ ./use-shared-mpeg2.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    bash
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
    libmpeg2
    libvorbis
    libzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL2_image}/include/SDL2"
    "-I${lib.getDev SDL2_ttf}/include/SDL2"
    "-I${lib.getDev SDL2_mixer}/include/SDL2"
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
