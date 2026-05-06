{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  curl,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "snarkos";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "AleoHQ";
    repo = "snarkOS";
    rev = "v${version}";
    sha256 = "sha256-P/ufTzTWUYAdqgyUI+sc1ZU5xTSQUUBWbWkyCm2QEsA=";
  };

  cargoHash = "sha256-/5CJ6erw+h551/+bVuMBVy+I5UwNyNYhBf/j3SgOmQE=";

  auditable = false;

  # buildAndTestSubdir = "cli";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    rustPlatform.bindgenHook
  ];

  env = {
    # Needed to get openssl-sys to use pkg-config.
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin
  [
    curl
  ];

  # some tests are flaky and some need network access
  # TODO finish filtering the tests to enable them
  doCheck = !stdenv.hostPlatform.isLinux;
  # checkFlags = [
  #   # tries to make a network access
  #   "--skip=rpc::rpc::tests::test_send_transaction_large"
  #   # flaky test
  #   "--skip=helpers::block_requests::tests::test_block_requests_case_2ca"
  # ];

  meta = {
    description = "Decentralized Operating System for Zero-Knowledge Applications";
    homepage = "https://snarkos.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
    mainProgram = "snarkos";
  };
}
