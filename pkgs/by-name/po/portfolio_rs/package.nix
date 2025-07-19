{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portfolio_rs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "MarkusZoppelt";
    repo = "portfolio_rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xWoON6VSYF5AH5X+A+238TWprvb7pHyzRp6E6A6Ns3o=";
  };

  cargoHash = "sha256-YUSAgfO6b55FaPKWxwJgi0RTf2s+xO51sNaFZTKD+p4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Skip network-dependent tests during build
  checkFlags = [
    "--skip=test_get_quote_name"
    "--skip=test_get_quote_price"
    "--skip=test_get_historic_price"
    "--skip=test_handle_position"
    "--skip=test_get_historic_total_value"
  ];

  meta = {
    description = "Command line tool for managing financial investment portfolios.";
    homepage = "https://github.com/MarkusZoppelt/portfolio_rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MarkusZoppelt ];
  };
})
