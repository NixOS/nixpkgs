{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  discord-rpc,
  fluidsynth,
  libebur128,
  libsndfile,
  libxmp,
  nix-update-script,
  openal,
  python3,
  sdl3,
  versionCheckHook,
  yyjson,
  withDiscordRpc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nugget-doom";
  version = "6.0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MrAlaux";
    repo = "Nugget-Doom";
    tag = "nugget-doom-${finalAttrs.version}";
    hash = "sha256-m2GGGqRY49Y9hBkPxeUcdEK9JwztOr3fcT3NCPO73Wc=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    sdl3
    fluidsynth
    libebur128
    libsndfile
    libxmp
    openal
    yyjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
  ++ lib.optionals withDiscordRpc [ discord-rpc ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_DISCORD_RPC" withDiscordRpc)
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "nugget-doom-(.*)"
    ];
  };

  meta = {
    description = "Doom source port forked from Woof! with additional features";
    homepage = "https://github.com/MrAlaux/Nugget-Doom";
    changelog = "https://github.com/MrAlaux/Nugget-Doom/releases/tag/nugget-doom-${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "nugget-doom";
  };
})
