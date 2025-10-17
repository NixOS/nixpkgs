{
  bitcoind,
  electrum,
  fetchFromGitHub,
  lib,
  rocksdb_8_3,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "blockstream-electrs";
  version = "0.4.1-unstable-2024-11-25";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "electrs";
    rev = "680eacaa8360d5f46eaae9611a3097ba183795c6";
    hash = "sha256-oDM4arH3aplgcS49t/hy5Rqt36glrVufd3F4tw3j1zo=";
  };

  cargoHash = "sha256-X2C69ui3XiYP1cg9FgfBbJlLLMq1SCw+oAL20B1Fs30=";

  nativeBuildInputs = [
    # Needed for librocksdb-sys
    rustPlatform.bindgenHook
  ];

  env = {
    # Dynamically link rocksdb
    ROCKSDB_INCLUDE_DIR = "${rocksdb_8_3}/include";
    ROCKSDB_LIB_DIR = "${rocksdb_8_3}/lib";

    # External binaries for integration tests are provided via nixpkgs. Skip
    # trying to download them.
    BITCOIND_SKIP_DOWNLOAD = true;
    ELECTRUMD_SKIP_DOWNLOAD = true;
    ELEMENTSD_SKIP_DOWNLOAD = true;
  };

  # Only build the service
  cargoBuildFlags = [
    "--package=electrs"
    "--bin=electrs"
  ];

  # Some upstream dev-dependencies (electrumd, elementsd) currently fail to
  # build on non-x86_64-linux platforms, even if downloading is skipped.
  # TODO(phlip9): submit a PR to fix this
  doCheck = stdenv.hostPlatform.system == "x86_64-linux";

  # Build tests in debug mode to reduce build time
  checkType = "debug";

  # Integration tests require us to pass in some external deps via env.
  preCheck = lib.optionalString doCheck ''
    export BITCOIND_EXE=${bitcoind}/bin/bitcoind
    export ELECTRUMD_EXE=${electrum}/bin/electrum
  '';

  # Make sure the final binary actually runs
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electrs --version
  '';

  meta = {
    description = "Efficient re-implementation of Electrum Server in Rust";
    longDescription = ''
      A blockchain index engine and HTTP API written in Rust based on
      [romanz/electrs](https://github.com/romanz/electrs).

      Used as the backend for the [Esplora block explorer](https://github.com/Blockstream/esplora)
      powering <https://blockstream.info>.

      API documentation [is available here](https://github.com/blockstream/esplora/blob/master/API.md).

      Documentation for the database schema and indexing process [is available here](https://github.com/Blockstream/electrs/blob/new-index/doc/schema.md).
    '';
    homepage = "https://github.com/Blockstream/electrs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phlip9 ];
    mainProgram = "electrs";
  };
}
