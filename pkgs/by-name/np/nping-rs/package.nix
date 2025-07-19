{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "nping-rs";
  version = "0.4.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    rev = "refs/tags/v${version}";
    hash = "sha256-2URMVGjoGfTdi1SSQhRK+JHimnsHHisybPT5KHqIHd0=";
  };

  cargoHash = "sha256-aPZ9A4IUOIhLhboTvbNTW5XoH99CZ159p3hfied7Anc=";

  meta = {
    description = "Ping Tool in Rust with Real-Time Data and Visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "nping-rs";
  };
}
