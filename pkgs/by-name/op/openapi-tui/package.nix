{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-rC0lfWZpiiAAShyVDqr1gKTeWmWC+gVp4UmL96Y81mE=";
  };

  cargoHash = "sha256-911ARjYvTNqLVVUWxATbtiKXOC9AqalFvDvp/qAef1Q=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "openapi-tui";
  };
}
