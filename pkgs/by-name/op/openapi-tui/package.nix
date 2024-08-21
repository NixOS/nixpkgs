{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-y8A43FV3PfYHaMMHE3uGRBaftga/pVSivCfV4iwUROA=";
  };

  cargoHash = "sha256-I1eTJDtQM9WKluOZJGfQT4Wn9TFyTu6ZcPFuh8wZIWI=";

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
