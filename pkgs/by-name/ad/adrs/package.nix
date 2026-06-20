{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adrs";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PB/BuZP2pvYJCjaazEPs9d2ik8Fs7nuTnHdLREsu+wQ=";
  };

  cargoHash = "sha256-RzX3moZog5BIppvWtQcU4Yauk4hZQfc8ZuFkvRs5jXA=";

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
})
