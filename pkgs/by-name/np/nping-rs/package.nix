{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "nping-rs";
  version = "0.2.0-beta.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    rev = "refs/tags/v${version}";
    hash = "sha256-sXCADiwaKW1bi4lInRcMeOHDLo4ikLKk6ujATPL2OWU=";
  };

  cargoHash = "sha256-cUfEUK3VNvbd/JFsmY9mnhjLygHPTLn1CaBQe9F/X3U=";

  meta = {
    description = "Ping Tool in Rust with Real-Time Data and Visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "nping-rs";
  };
}
