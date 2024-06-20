{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rcp";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${version}";
    hash = "sha256-nNMcZyJAvqxVSoytmfSqsfk1yVzzZ5aIOj72L+jFAAM=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    IOKit
  ]);

  cargoHash = "sha256-3+w+pTws8WjrUqIWYGbE2V438mVUUyrjBH9mHI8uRMQ=";

  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # this test also sets setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
  ];

  meta = with lib; {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with maintainers; [ wykurz ];
    # = note: Undefined symbols for architecture x86_64: "_utimensat"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
