{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-features-manager";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ToBinio";
    repo = "cargo-features-manager";
    rev = "v${version}";
    hash = "sha256-ez8WIDHV6/f0Kk6cvzB25LoYBPT+JTzmOWrSxXXzpBc=";
  };

  cargoHash = "sha256-G1MBH4c9b/h87QgCleTMnndjWc70KZI+6W4KWaxk28o=";

  meta = {
    description = "A command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/ToBinio/cargo-features-manager";
    changelog = "https://github.com/ToBinio/cargo-features-manager/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "cargo-features-manager";
  };
}
