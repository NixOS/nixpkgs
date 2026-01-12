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
    tag = "v${version}";
    hash = "sha256-C9Kg7xY3Q0xsd2DlUcc3OM+/hyzmwz55oi6Ul3K7zkM=";
  };

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
