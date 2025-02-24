{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
}:

let
  pname = "gfold";
  version = "4.6.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    hash = "sha256-z5E+YS2zO4zgsW7mZbVN0z4HOurqoXwXn8hQc++9tks=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7VPMWou23iJHzKFMXirsjlIvq8kyAnNSeQ26IKxfNZE=";

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
