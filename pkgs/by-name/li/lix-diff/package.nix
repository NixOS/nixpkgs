{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "lix-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ehASke8ZpvHkQI9bCV3/9i1QG67hjSIMoIMQDlbODxU=";
  };

  cargoHash = "sha256-ghwCwIg0PDfUfiHnwiUy8kNjPEgVWk92zA5ZnlD8BO8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/isabelroses/lix-diff";
    description = "Lix plugin for diffing two generations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
})
