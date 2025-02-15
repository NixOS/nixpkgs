{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-EUWL16cHgPF88CoCD9sqnxLOlmWoe1tu5ps01AYwwzc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JlfsWR0NAvGBljxlBuyIT1vffvXaGkf6AVW70/c+JBs=";

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
