{ bitcoind
, darwin
, electrum
, fetchFromGitHub
, lib
, rocksdb_8_3
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "blockstream-electrs";
  version = "2024-05-29";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "electrs";
    rev = "e11cd561a197f8c0e4839721b4e1877b2a41053f";
    hash = "sha256-uKhhnA+xSzZoS/NgBd+xANW9V2c2n3aszto9V0igiv8=";
  };

  patches = [
    # + Wire up nixpkgs-provided external binaries correctly.
    # + Update test assertion for newer electrum version in nixpkgs.
    ./fix-tests.patch
  ];

  # Vendor the Cargo.lock in nixpkgs as there are git dependencies
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "electrum-client-0.8.0" = "sha256-HDRdGS7CwWsPXkA1HdurwrVu4lhEx0Ay8vHi08urjZ0=";
      "electrumd-0.1.0" = "sha256-M9yd53LsKheS9dQwDQKjcwbBM+66QGoNXIoSgV8G/Ao=";
      "jsonrpc-0.12.0" = "sha256-lSNkkQttb8LnJej4Vfe7MrjiNPOuJ5A6w5iLstl9O1k=";
    };
  };

  nativeBuildInputs = [
    # Needed for librocksdb-sys
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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
  cargoBuildFlags = [ "--package=electrs" "--bin=electrs" ];

  # Some upstream dev-dependencies (electrumd, elementsd) currently fail to
  # build on non-x86_64-linux platforms, even if downloading is skipped.
  # TODO(phlip9): submit a PR to fix this
  doCheck = stdenv.hostPlatform.system == "x86_64-linux";

  # Build tests in debug mode to reduce build time
  checkType = "debug";

  # Integration tests require us to pass in some external deps via env
  preCheck = ''
    export BITCOIND_EXE=${bitcoind}/bin/bitcoind
    export ELECTRUMD_EXE=${electrum}/bin/electrum
  '';

  # Make sure the final binary actually runs
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/electrs --version
  '';

  meta = {
    description = "An efficient re-implementation of Electrum Server in Rust";
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
