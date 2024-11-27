{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-features-manager";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ToBinio";
    repo = "cargo-features-manager";
    rev = "v${version}";
    hash = "sha256-g4iJ9iZp7vmnSE/P76ocDu/XKeSbPjosB97ojLI30oE=";
  };

  cargoHash = "sha256-O0MQAgOZdiVW6GU69BAn2beDDqNNwijLlmfC7I3Qd0A=";

  meta = {
    description = "Command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/ToBinio/cargo-features-manager";
    changelog = "https://github.com/ToBinio/cargo-features-manager/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "cargo-features-manager";
  };
}
