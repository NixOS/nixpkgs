{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rcp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${version}";
    hash = "sha256-e6m3E1R7o4X9cPEy/ayUIsK0xhRaVsAFDAwObJrDJPA=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    IOKit
  ]);

  cargoHash = "sha256-croFSe37yQa9LijaNxKHrZlcJdExz9SweOoG21PPn9E=";

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
