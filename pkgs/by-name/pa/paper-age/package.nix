{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "paper-age";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${version}";
    hash = "sha256-xoxrNNlpDFXuQwltZ52SkGe0z6+B4h1Jy4XRtvQDiAg=";
  };

  cargoHash = "sha256-FO69bmUhP6S3MRbVZllxmpn1GuM8fplciAka46Dz2Yg=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "paper-age";
  };
}
