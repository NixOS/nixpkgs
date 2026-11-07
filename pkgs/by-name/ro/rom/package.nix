{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rom";
  version = "0.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "rom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDoke7/RqXX/1ccS3No2DnkXo8Im8eokrGZyCDayHlk=";
  };

  cargoHash = "sha256-TQj4Mgcd948vPPsYrbOTgVpmyEHOxysa/a4a4m+WbIk=";

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
