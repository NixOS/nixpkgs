{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
}:

let
  pname = "gfold";
  version = "2025.2.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    hash = "sha256-WgSFLAhPJe7U4ovanqqxYArmPHmN+JRcVHjXYATV+wQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zU6ixAlac5TKTVm4vc1qVDYtHVoNDildJpi+RrBwV9Y=";

  passthru.tests.version = testers.testVersion {
    package = gfold;
    command = "gfold --version";
    inherit version;
  };

  meta = with lib; {
    description = "CLI tool to help keep track of your Git repositories, written in Rust";
    homepage = "https://github.com/nickgerace/gfold";
    license = licenses.asl20;
    maintainers = [ maintainers.sigmanificient ];
    platforms = platforms.unix;
    mainProgram = "gfold";
  };
}
