{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deff";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "flamestro";
    repo = "deff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CZl9KDeBVo8qgYZNgQST8ThBwA7C6WjG3Dn1IE2nw7g=";
  };

  cargoHash = "sha256-rjt4513Cs3tDM3XJ+Qx4E2ECCowGBq6zAqaxRtvGNVg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive, side-by-side file review for git diffs with per-file navigation, vertical and horizontal scrolling, syntax highlighting, and added/deleted line tinting";
    homepage = "https://github.com/flamestro/deff";
    changelog = "https://github.com/flamestro/deff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "deff";
  };
})
