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

<<<<<<< HEAD
  env.OPENSSL_NO_VENDOR = true;
=======
  OPENSSL_NO_VENDOR = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

<<<<<<< HEAD
  meta = {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
=======
  meta = with lib; {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "openapi-tui";
  };
}
