{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  fontconfig,
  freealut,
  libglut,
  gettext,
  libGL,
  libGLU,
  openal,
  quesoglc,
  clanlib,
  libXrender,
  libmikmod,
  alsa-lib,
  nix-update-script,
  libXinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "methane";
  version = "2.1.0";

  src = fetchFromGitHub {
    repo = "methane";
    owner = "rombust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rByJqkhYsRuv0gTug+vP2qgkRY8TnX+Qx4/MbAmPTOU=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    fontconfig
    freealut
    libglut
    libGL
    libGLU
    openal
    quesoglc
    clanlib
    libXrender
    libXinerama
    libmikmod
    alsa-lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/ $out/share/methane/ $out/share/docs/
    cp methane $out/bin
    cp -r resources/* $out/share/methane/.
    cp -r docs/* $out/share/docs/.
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rombust/methane";
    description = "Clone of Taito's Bubble Bobble arcade game released for Amiga in 1993 by Apache Software";
    mainProgram = "methane";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nixinator ];
    platforms = [ "x86_64-linux" ];
  };
})
