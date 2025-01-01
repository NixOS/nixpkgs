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

  cargoHash = "sha256-FmtExP4M6MiKNlekNZZRGs6Y/AY+OQrHC7dmkxkyPQQ=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "paper-age";
  };
}
