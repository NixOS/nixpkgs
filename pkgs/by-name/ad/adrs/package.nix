{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adrs";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dHiXnLARzviShnih1gkMehMpsztaofFXToDStd3GWkY=";
  };

  cargoHash = "sha256-RThX4n4qn/0cPm8GZLnzbNt5VrMWf0wMXz0G9Im9CHk=";

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
