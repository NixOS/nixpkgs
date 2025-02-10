{
  lib,
  cacert,
  curl,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  stdenv,
  zig,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "cargo-lambda";
    repo = "cargo-lambda";
    tag = "v${version}";
    hash = "sha256-58kVtwBZEAlv9eVesqmWMZ+KxAwEiGMm8mCf9X5tPMI=";
  };

  cargoHash = "sha256-DoMIVpYtEHvYSW2THpZFdhoFI0zjC70hYnwnzGwkJ4Q=";

  nativeCheckInputs = [ cacert ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
    ];

  checkFlags = [
    # Tests disabled because they access the network.
    "--skip=test_download_example"
  ];

  # Remove files that don't make builds reproducible:
  # - Remove build.rs file that adds the build date to the version.
  # - Remove cargo_lambda.rs that contains tests that reach the network.
  postPatch = ''
    rm crates/cargo-lambda-cli/build.rs
    rm crates/cargo-lambda-cli/tests/cargo_lambda.rs
  '';

  postInstall = ''
    wrapProgram $out/bin/cargo-lambda --prefix PATH : ${lib.makeBinPath [ zig ]}
  '';

  CARGO_LAMBDA_BUILD_INFO = "(nixpkgs)";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand to help you work with AWS Lambda";
    mainProgram = "cargo-lambda";
    homepage = "https://cargo-lambda.info";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      taylor1791
      calavera
    ];
  };
}
