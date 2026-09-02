{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpng,
  libsamplerate,
  pkg-config,
  python3,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  zlib,

  enableTruecolor ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crispy-doom";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "crispy-doom";
    tag = "crispy-doom-${finalAttrs.version}";
    hash = "sha256-LJLqlPSOarmm5oqSLMilxNMJl4+uKukDl/b58NpZ8VI=";
  };

  postPatch = ''
    for script in $(grep -lr '^#!/usr/bin/env python3$'); do patchShebangs $script; done
  '';

  configureFlags = lib.optional enableTruecolor [ "--enable-truecolor" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    libpng
    libsamplerate
    SDL2
    SDL2_mixer
    SDL2_net
    zlib
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "https://fabiangreffrath.github.io/crispy-homepage";
    changelog = "https://github.com/fabiangreffrath/crispy-doom/releases/tag/crispy-doom-${finalAttrs.version}";
    description = "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom";
    longDescription = ''
      Crispy Doom is a limit-removing enhanced-resolution Doom source port based on Chocolate Doom.
      Its name means that 640x400 looks \"crisp\" and is also a slight reference to its origin.
    '';
    mainProgram = "crispy-doom";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      Gliczy
      keenanweaver
    ];
  };
})
