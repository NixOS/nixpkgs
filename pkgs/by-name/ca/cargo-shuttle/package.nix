{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-shuttle";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
    rev = "v${version}";
    hash = "sha256-AJ+7IUxi5SRRWw0EHh9JmQHkdQU3Mhd1Nmo1peEG2zg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RqPVFovDaD2rW31HyETJfQ0qVwFxoGEvqkIgag3H6KU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
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
