{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-alternative-startup";
  version = "0-unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "Drakulix";
    repo = "cosmic-ext-alternative-startup";
    rev = "8ceda00197c7ec0905cf1dccdc2d67d738e45417";
    hash = "sha256-0kqn3hZ58uQMl39XXF94yQS1EWmGIK45/JFTAigg/3M=";
  };

  cargoHash = "sha256-DeMkAG2iINGden0Up013M9mWDN4QHrF+FXoNqpGB+mg=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "cosmic-ext-alternative-startup";
    description = "Alternative entry point for cosmic-sessions compositor IPC interface";
    homepage = "https://github.com/Drakulix/cosmic-ext-alternative-startup";
    license = lib.licenses.gpl3;
    maintainers = [ lib.teams.cosmic ];
  };
})
