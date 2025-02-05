{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "adrs";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    rev = "v${version}";
    hash = "sha256-a1vxo2Zw2fvCJeGaatNqf2h74t7pvWppYS2l2gbCF5k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VtMgvUifHddSncsKxtT5v44sDhihLgpbq38szvHVrVk=";

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
