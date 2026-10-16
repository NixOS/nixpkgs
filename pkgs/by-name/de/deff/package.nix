{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deff";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "flamestro";
    repo = "deff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dB3j6seUSGG3hrl3gY6EIjQLDUbHiXJGeVDq9dmAanw=";
  };

  cargoHash = "sha256-agNQs0X2o8qQdeRkwMbYdvReNPSFCnIlYDnSxBvnduo=";

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
