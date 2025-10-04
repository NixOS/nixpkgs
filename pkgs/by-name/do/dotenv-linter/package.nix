{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenv-linter";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "dotenv-linter";
    repo = "dotenv-linter";
    rev = "v${version}";
    sha256 = "sha256-HCP1OUWm/17e73TbinmDxYUi18/KXxppstyUSixjlSo=";
  };

  cargoHash = "sha256-lBHqvwZrnkSfmMXBmnhovbDn+pf5iLJepJjO/FKT1wY=";

  meta = with lib; {
    description = "Lightning-fast linter for .env files. Written in Rust";
    mainProgram = "dotenv-linter";
    homepage = "https://dotenv-linter.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ humancalico ];
  };
}
