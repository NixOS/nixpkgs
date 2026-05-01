{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "nbping";
  version = "0.6.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    tag = "v${version}";
    hash = "sha256-6eUsvNMQoJ5TUWPkOlmcJqdmxaXoBStnhiXiya+0nV8=";
  };

  cargoHash = "sha256-6+drbq9dQ5/Atzoz9VPS4BoYEPeM5OqPXUuM1AXP72g=";

  meta = {
    description = "Ping Tool in Rust with Real-Time Data and Visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "nbping";
  };
}
