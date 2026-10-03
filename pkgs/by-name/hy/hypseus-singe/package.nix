{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  makeWrapper,
  pkg-config,

  bash,
  libmpeg2,
  libvorbis,
  libx11,
  libzip,
  sdl3,
  sdl3-image,
  sdl3-mixer,
  sdl3-ttf,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypseus-singe";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "DirtBagXon";
    repo = "hypseus-singe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IRM64kLE13a84l9q+kUtVjqu3oBAo5/9GPqvCJgQ5uA=";
  };

  patches = [ ./use-shared-mpeg2.patch ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    bash
    libmpeg2
    libvorbis
    libzip
    sdl3
    sdl3-image
    sdl3-mixer
    sdl3-ttf
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
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
