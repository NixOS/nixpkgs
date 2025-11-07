{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portfolio_rs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "MarkusZoppelt";
    repo = "portfolio_rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WCz41eJciYwvljiyg5MESiz4eUXBpot7+j81PPyG+fY=";
  };

  cargoHash = "sha256-s+/IaajmdKu49nQ49RdjudgKW9KdAix0Ryj+N+wnuZU=";

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
