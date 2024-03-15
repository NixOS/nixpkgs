{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-7xkjlX3+/hdVN2PXoiXbouSoMLy0Qe8uMRlPHWJO5Ts=";
  };

  cargoHash = "sha256-U8TOms8C7vV64OKKdJhMAoOha9s2lBqfBWU7pyZ0h/s=";

  meta = with lib; {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "openapi-tui";
  };
}

