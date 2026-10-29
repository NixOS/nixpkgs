{
  bitcoind,
  electrum,
  fetchFromGitHub,
  lib,
  rocksdb,
  rust-jemalloc-sys,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "blockstream-electrs";
  version = "0.4.1-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "electrs";
    rev = "503b740cce2133fd07f451cbe93249a4e092b300";
    hash = "sha256-jFOEQwFDRVghCDFu0mybSLeTk9zWJSQW9clWFMkCa5A=";
  };

  cargoHash = "sha256-P8slOt07Fu6NNzYLEso3UQtfx7Yj+C4w98lq/Wr8oTk=";

  nativeBuildInputs = [
    # Needed for librocksdb-sys
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    # tikv-jemalloc-sys's vendored jemalloc configure breaks under gcc 15.
    rust-jemalloc-sys
  ];

  env = {
    # Dynamically link rocksdb
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";

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

  # flaky: wait_for_sync roundtrip races the wallet daemon startup
  checkFlags = [
    "--skip=test_electrum_balance"
    "--skip=test_electrum_history"
    "--skip=test_electrum_payment"
  ];

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
