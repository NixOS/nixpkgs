{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  autoreconfHook,
  libpng,
  libsamplerate,
  nix-update-script,
  pkg-config,
  python3,
  versionCheckHook,
  zlib,

  enableTruecolor ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crispy-doom";
  version = "7.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "crispy-doom";
    tag = "crispy-doom-${finalAttrs.version}";
    hash = "sha256-OzhhiuU6IH2SqMFG8y2UeOeOvzTB4F3Uu2Vp+96VgFk=";
  };

  postPatch = ''
    patchShebangs --build man data textscreen/fonts
  '';

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
  configureFlags = lib.optionals enableTruecolor [ "--enable-truecolor" ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "crispy-doom-(.*)"
    ];
  };

  meta = {
    description = "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom";
    longDescription = ''
      Crispy Doom is a limit-removing enhanced-resolution Doom source port based on Chocolate Doom.
      Its name means that 640x400 looks \"crisp\" and is also a slight reference to its origin.
    '';
    homepage = "https://fabiangreffrath.github.io/crispy-homepage";
    changelog = "https://github.com/fabiangreffrath/crispy-doom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Gliczy
      keenanweaver
    ];
    platforms = lib.platforms.unix;
    mainProgram = "crispy-doom";
  };
})
