{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, perl
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-xs+XsXED74UP+Z/0KnXtqjNZbiqPESQDciDCx2KSVac=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-rL31GzYdRAijaa7V3xaotxAKpF7FqkKTp0KHAK41rmQ=";

  meta = with lib; {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "openapi-tui";
  };
}

