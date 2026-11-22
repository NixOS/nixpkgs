{
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miri";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "MintyDoggo";
    repo = "miri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nxPMvUyV2vSTANLJdQ4kagqulZaLKmbJjAINPMbeNc4=";
  };

  cargoHash = "sha256-3qRY9Wm/eQFGhVPdOigB0qmI7qG4FZx3/gbOLGPmvz4=";

  __structuredAttrs = true;

  meta = {
    description = "Niri extension adding optional tiling layouts such as Master Stack";
    homepage = "https://github.com/MintyDoggo/miri";
    changelog = "https://github.com/MintyDoggo/miri/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      miangraham
    ];
    mainProgram = "miri";
    platforms = lib.platforms.linux;
  };
})
