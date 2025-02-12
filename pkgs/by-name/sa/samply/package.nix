{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "samply";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7bf1lDIZGhRpvnn8rHNwzH2GBY8CwtYCjuRAUTQgbsA=";
  };

  # Can't use fetchCargoVendor:
  # https://github.com/NixOS/nixpkgs/issues/377986
  cargoLock.lockFile = ./Cargo.lock;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "Command line profiler for macOS and Linux";
    mainProgram = "samply";
    homepage = "https://github.com/mstange/samply";
    changelog = "https://github.com/mstange/samply/releases/tag/samply-v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
