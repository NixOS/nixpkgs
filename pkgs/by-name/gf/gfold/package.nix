{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
}:

let
  pname = "gfold";
  version = "2025.7.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    rev = version;
    hash = "sha256-EWQ17aEOEZnYEe3WJpyNuC+r4tv8DP1fYFH6fII2p+8=";
  };

  cargoHash = "sha256-3hzcYPD/w2vbsSuuHNAD2Oyqw0B0PIdERGgCAvAiQpk=";

  passthru.tests.version = testers.testVersion {
    package = gfold;
    command = "gfold --version";
    inherit version;
  };

  meta = {
    description = "CLI tool to help keep track of your Git repositories, written in Rust";
    homepage = "https://github.com/nickgerace/gfold";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = lib.platforms.unix;
    mainProgram = "gfold";
  };
}
