{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paper-age";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Du5GYk2iWMuUGQ1F6pubDNyMngXpO2ZSk/KpZvHqpcI=";
  };

  cargoHash = "sha256-Ba0Hp3g3aKr7f6RidxFcES2DExuq/jHH5Gg3bcIoH8k=";

  meta = {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "paper-age";
  };
})
