{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paper-age";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wKhq7AtplQ+Yl5/pVaBY2gLu3KklPXqUEd6cVabHtVo=";
  };

  cargoHash = "sha256-LcGTnWgccTjrfDGKsnArxtSksr8lMG392HhYKVy1Lew=";

  meta = {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "paper-age";
  };
})
