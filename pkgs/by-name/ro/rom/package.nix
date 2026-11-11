{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rom";
  version = "0.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "rom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQMxdZKSqb6EyYCIIre2xPnR+leWf8lmtiMT915PJbc=";
  };

  cargoHash = "sha256-eO568DgN0zfFpX+B/DjlFBfmIDRrkHlZgnRn30ka7T8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flamboyant output monitor for the Nix build tool";
    homepage = "https://github.com/manic-systems/rom";
    changelog = "https://github.com/manic-systems/rom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      faukah
      amaanq
      NotAShelf
      qweered
    ];
    mainProgram = "rom";
  };
})
