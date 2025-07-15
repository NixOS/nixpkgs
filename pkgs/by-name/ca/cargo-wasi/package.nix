{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  stdenv,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wasi";
  version = "0.1.28";

  src = fetchCrate {
    inherit version;
    pname = "cargo-wasi-src";
    hash = "sha256-fmQ23BtcBUPNcgZgvNq85iqdY6WRUhqwAp4aIobqMIw=";
  };

  cargoHash = "sha256-GTpFgoKtAH06xBJ5X6w37ApTVjBLX7S4asWOB4/mN4g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  # Checks need to be disabled here because the current test suite makes assumptions
  # about the surrounding environment that aren't Nix friendly. See these lines for specifics:
  # https://github.com/bytecodealliance/cargo-wasi/blob/0.1.28/tests/tests/support.rs#L13-L18
  doCheck = false;

  meta = with lib; {
    description = "Lightweight Cargo subcommand to build code for the wasm32-wasi target";
    mainProgram = "cargo-wasi";
    homepage = "https://bytecodealliance.github.io/cargo-wasi";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
