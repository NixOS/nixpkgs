{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paper-age";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xoxrNNlpDFXuQwltZ52SkGe0z6+B4h1Jy4XRtvQDiAg=";
  };

  cargoHash = "sha256-FO69bmUhP6S3MRbVZllxmpn1GuM8fplciAka46Dz2Yg=";

  meta = {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "paper-age";
  };
})
