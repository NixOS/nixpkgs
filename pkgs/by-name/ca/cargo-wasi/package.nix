{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  stdenv,
  openssl,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wasi";
  version = "0.1.28";

  src = fetchCrate {
    inherit version;
    pname = "cargo-wasi-src";
    sha256 = "sha256-fmQ23BtcBUPNcgZgvNq85iqdY6WRUhqwAp4aIobqMIw=";
  };

  cargoHash = "sha256-yXtxznUp2gECq2CvRByiFzbTjYtWvTheDjGoynJWb+o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ]);

  # Checks need to be disabled here because the current test suite makes assumptions
  # about the surrounding environment that aren't Nix friendly. See these lines for specifics:
  # https://github.com/bytecodealliance/cargo-wasi/blob/0.1.28/tests/tests/support.rs#L13-L18
  doCheck = false;

  meta = with lib; {
    description = "A lightweight Cargo subcommand to build code for the wasm32-wasi target";
    mainProgram = "cargo-wasi";
    homepage = "https://bytecodealliance.github.io/cargo-wasi";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
