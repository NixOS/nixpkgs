{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-features-manager";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ToBinio";
    repo = "cargo-features-manager";
    rev = "v${version}";
    hash = "sha256-NjXJCrLsX52M7CBg8wdgwlK3gaGiznfdRGz7BAbVVPk=";
  };

  cargoHash = "sha256-1/bCyScvWQYeGZRitvksww4uvrzhifRBYcYPgGY2GRo=";

  meta = {
    description = "Command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/ToBinio/cargo-features-manager";
    changelog = "https://github.com/ToBinio/cargo-features-manager/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "cargo-features-manager";
  };
}
