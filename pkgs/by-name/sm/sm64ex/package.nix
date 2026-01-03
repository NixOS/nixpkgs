{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  pkg-config,
  audiofile,
  SDL2,
  libGL,
  hexdump,
  sm64baserom,
  region ? "us",
  _60fps ? true,
}:
let
  baseRom = (sm64baserom.override { inherit region; }).romPath;
in
stdenv.mkDerivation (finalAttrs: {

  pname = "sm64ex";
  version = "0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "d7ca2c04364a6dd0dac58b47151e04e26887e6f0";
    hash = "sha256-n3ecY97UB/fdTZpy78CB4DxyHyjK+L6AAuNpvnmVoss=";
  };

  patches = lib.optionals _60fps [
    (fetchpatch {
      name = "60fps_ex.patch";
      url = "file://${finalAttrs.src}/enhancements/60fps_ex.patch";
      hash = "sha256-2V7WcZ8zG8Ef0bHmXVz2iaR48XRRDjTvynC4RPxMkcA=";
    })
  ];

  nativeBuildInputs = [
    python3
    pkg-config
    hexdump
  ];

  buildInputs = [
    audiofile
    SDL2
    libGL
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "VERSION=${region}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "OSX_BUILD=1"
  ];

  preBuild = ''
    patchShebangs extract_assets.py
    ln -s ${baseRom} ./baserom.${region}.z64
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/${region}_pc/sm64.${region}.f3dex2e $out/bin/sm64ex

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
    longDescription = ''
      Note that you must supply a baserom yourself to extract assets from.
      If you are not using an US baserom, you must overwrite the "region" attribute with either "eu" or "jp".
      If you would like to use patches sm64ex distributes as makeflags, add them to the "compileFlags" attribute.
    '';
    mainProgram = "sm64ex";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = lib.platforms.unix;
  };
})
