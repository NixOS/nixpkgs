{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portfolio_rs";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "MarkusZoppelt";
    repo = "portfolio_rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1ECy27iBdG0/mql6Xg0SgJWYSLGNMKGCWuaUOriVRIs=";
  };

  cargoHash = "sha256-KNvQWkEuUSBr7qQrS0dXROVjeqfD4tmqSYybywIb+Mw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    aws-lc
  ];

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
