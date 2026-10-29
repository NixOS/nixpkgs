{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bmm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "bmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sfAUvvZ/LKOXfnA0PB3LRbPHYoA+FJV4frYU+BpC6WI=";
  };

  cargoHash = "sha256-+o8bYi4Pe9zwiDBUMllpF+my7gp3iLX0+DntFtN7PoI=";

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Get to your bookmarks in a flash";
    homepage = "https://github.com/dhth/bmm";
    changelog = "https://github.com/dhth/bmm/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ faukah ];
    mainProgram = "bmm";
  };
})
