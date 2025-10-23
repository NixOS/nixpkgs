{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-shuttle";
  version = "0.57.3";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
    rev = "v${version}";
    hash = "sha256-qPevl75wmOYVhTgMiJOi+6j8LBWKzM7HPhd5mdf2B+8=";
  };

  cargoHash = "sha256-H2fy2NQvLQEzbQik+nrUvoYZaWQRXX6PpO9LcYfiF2I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  cargoBuildFlags = [
    "-p"
    "cargo-shuttle"
  ];

  cargoTestFlags = cargoBuildFlags ++ [
    # other tests are failing for different reasons
    "init::shuttle_init_tests::"
  ];

  meta = with lib; {
    description = "Cargo command for the shuttle platform";
    mainProgram = "cargo-shuttle";
    homepage = "https://shuttle.rs";
    changelog = "https://github.com/shuttle-hq/shuttle/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
