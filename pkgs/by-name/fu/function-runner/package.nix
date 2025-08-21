{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "function-runner";
    rev = "v${version}";
    sha256 = "sha256-xzajHtFs7cp7D1ZdG3jBFbjheTSgWR/Vz4fkew3iAkc=";
  };

  cargoHash = "sha256-fRLBKHsb+y2uyqWejRBmJm+t5CAkL9ScQl6iVCksahU=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
