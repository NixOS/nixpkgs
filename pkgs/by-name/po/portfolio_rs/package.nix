{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portfolio_rs";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "MarkusZoppelt";
    repo = "portfolio_rs";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-SuukTNEfPOCCE5bg08/K7M68R2dAe75cch39whtcSWg=";
  };

  cargoHash = "sha256-L14Cu/Gex6FGeSEL7zcY+E6khtkH6fwzqkjHm67ALUw=";
=======
    hash = "sha256-WCz41eJciYwvljiyg5MESiz4eUXBpot7+j81PPyG+fY=";
  };

  cargoHash = "sha256-s+/IaajmdKu49nQ49RdjudgKW9KdAix0Ryj+N+wnuZU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
