{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZdblRMvUeMcuW6Tji2FQe9Nfg1yRMvbeRiPABsQGBcI=";
  };

  cargoHash = "sha256-A30ApbAjPn7d+LzYp+Yms3nydHW9kc7bUmQ3oXMdcyw=";

  meta = {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nintron ];
  };
}
