{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "adrs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${version}";
    hash = "sha256-LjuEYOZJzptryjtqmfH5L/BI+9daLPAGSkAkXeE7Z/E=";
  };

  cargoHash = "sha256-mevUqsqFDfF2dMYSdc0eGxh55W7shLSo8e5NpbDI/Zo=";

  meta = {
    description = "Command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/joshrotenberg/adrs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "adrs";
  };
}
