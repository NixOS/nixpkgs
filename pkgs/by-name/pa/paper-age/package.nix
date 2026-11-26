{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paper-age";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BVHVM49YUIdkSmYkQmG7MrRQykC9Y6JtAEtylld4pro=";
  };

  cargoHash = "sha256-iM8jsQgfSG0Od1GycrX+TzJZ88SfW1nMMaY+LKaeBTY=";

  meta = {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "paper-age";
  };
})
