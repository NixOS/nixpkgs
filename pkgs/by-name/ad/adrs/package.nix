{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "adrs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    rev = "v${version}";
    hash = "sha256-BnbI5QsrnyEQFpTWqOPrbZnVa7J3vaByO9fnKd5t64o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ep1Y2PDNesaDzEc2JNoKZjFSay1utZiNR5eQYhdqiUU=";

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
