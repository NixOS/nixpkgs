{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libopus,
  whisper-cpp,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "galene-stt";
  version = "0.3-unstable-2026-09-19";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene-stt";
    rev = "314b7a9a00f453defc62950876fc8ec401ba093e";
    hash = "sha256-yLEVjsvyWm9M0/NdS6wczgzWpuxvvK3YAJ4IyP7EHCk=";
  };

  vendorHash = "sha256-tqOrqQYCFq2g6maruEFB7bZqKT99fDHA8nfi1cdVkeg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libopus
    whisper-cpp
  ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Speech-to-text support for Galene";
    homepage = "https://github.com/jech/galene-stt";
    changelog = "https://github.com/jech/galene-stt/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    mainProgram = "galene-stt";
  };
})
