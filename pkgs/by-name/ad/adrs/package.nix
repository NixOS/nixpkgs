{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "adrs";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    rev = "v${version}";
    hash = "sha256-5rvdW2UntseSsKFndrDj9ogH/qYN+KymuOsuqS0/C3M=";
  };

  cargoHash = "sha256-WqsZ+ICfKrackQ5dMs/WvF3inJX+k9LhxAJkXmaVAtY=";

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
