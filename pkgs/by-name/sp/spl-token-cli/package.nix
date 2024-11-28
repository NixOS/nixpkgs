{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  systemdMinimal,
  openssl,
  protobuf,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "spl-token-cli";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana-program-library";
    rev = "refs/tags/token-cli-v${version}";
    hash = "sha256-LV/QeQgnHI06/QJ1O6gXP6esPcJew8/LqFgQLRRGPP8=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    protobuf
  ];

  postPatch = ''
    substituteInPlace single-pool/cli/tests/test.rs \
      --replace-fail "../../target/deploy/spl_single_pool.so" "../../target/${stdenv.hostPlatform.config}/release/libspl_single_pool.so"
  '';

  preCheck = ''
    rm single-pool/js/packages/classic/tests/fixtures/spl_single_pool.so
    cp target/${stdenv.hostPlatform.rust.rustcTarget}/release/libspl_single_pool.so single-pool/js/packages/classic/tests/fixtures/spl_single_pool.so
  '';

  buildInputs = [
    systemdMinimal # for libudev
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  cargoHash = "sha256-k0fyf8qMSzQvooSspJT1EoPNzhnKDGl7zaSxTJUCZDc=";

  meta = {
    homepage = "https://spl.solana.com/token";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/solana-labs/solana-program-library/releases/tag/token-cli-v${version}";
    mainProgram = "";
    license = lib.licenses.asl20;
    description = "SPL Token program command-line utility";
  };
}
