{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, Security
, curl
, pkg-config
, openssl
, llvmPackages
}:
rustPlatform.buildRustPackage rec {
  pname = "snarkos";
  version = "unstable-2021-01-21";

  src = fetchFromGitHub {
    owner = "AleoHQ";
    repo = "snarkOS";
    rev = "7068dc0394139c887f5187288ca2af54bc729614";
    sha256 = "sha256-fgdIJX/Ep3amPAjo00BtNGSXhaItw41S1XliDXk6b7k=";
  };

  cargoSha256 = "sha256-bax7cnqVY49rdcWs73+KqW+dzPebKLlsbPvOM1d25zA=";

  # buildAndTestSubdir = "cli";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config llvmPackages.clang ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  OPENSSL_DIR="${lib.getDev openssl}";

  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

  # TODO check why rust compilation fails by including the rocksdb from nixpkgs
  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  # ROCKSDB_INCLUDE_DIR="${rocksdb}/include";
  # ROCKSDB_LIB_DIR="${rocksdb}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ Security curl ];

  # some tests are flaky and some need network access
  # TODO finish filtering the tests to enable them
  doCheck = !stdenv.isLinux;
  # checkFlags = [
  #   # tries to make a network access
  #   "--skip=rpc::rpc::tests::test_send_transaction_large"
  #   # flaky test
  #   "--skip=helpers::block_requests::tests::test_block_requests_case_2ca"
  # ];


  meta = with lib; {
    description = "A Decentralized Operating System for Zero-Knowledge Applications";
    homepage = "https://snarkos.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
}
