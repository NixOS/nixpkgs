{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "adrs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${version}";
    hash = "sha256-PAvn1yIptyiVG96BNXHPgc5rYEHyCTo42hh88dwxrhA=";
  };

  cargoHash = "sha256-va6s+nbW4vafnt6SqqdaeAF06Q30NEDqFVWDz9mYdAo=";

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
