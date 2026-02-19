{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openapi-tui";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = finalAttrs.version;
    hash = "sha256-rC0lfWZpiiAAShyVDqr1gKTeWmWC+gVp4UmL96Y81mE=";
  };

  cargoHash = "sha256-911ARjYvTNqLVVUWxATbtiKXOC9AqalFvDvp/qAef1Q=";

  # Do not vendor Oniguruma
  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    OPENSSL_NO_VENDOR = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    oniguruma
  ];

  meta = {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "openapi-tui";
  };
})
