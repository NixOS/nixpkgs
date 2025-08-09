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
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
    rev = "v${version}";
    hash = "sha256-37HQDiIgwxbMcFo7kM/SZ7dJzZc5CzL03xQNiMkG8l8=";
  };

  cargoHash = "sha256-CYpAsNzQyIPigZSY/PwzGhYHU0316odwkwvxdcVisYk=";

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
