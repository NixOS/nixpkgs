{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adrs";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XBSGK63MEpCy2jNqn2XPUmKXgmmRAYFKPupoRvG5R+8=";
  };

  cargoHash = "sha256-sdkUYSC2OmVIL8b3u6q0Lv9yWRiijTzI7l7ch3tszsc=";

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
