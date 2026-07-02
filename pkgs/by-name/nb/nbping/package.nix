{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "nbping";
  version = "0.7.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    tag = "v${version}";
    hash = "sha256-rGWYvYJs6vkG+HQuT4NJGMUUG9QzIhyJThgDWTC6/JI=";
  };

  cargoHash = "sha256-6AdqPm07lbMzeqihQC3mCoBYZ1cduGo1rCvYsF+4XL4=";

  meta = {
    description = "Ping Tool in Rust with Real-Time Data and Visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "nbping";
  };
}
