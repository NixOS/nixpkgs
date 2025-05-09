{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "function-runner";
    rev = "v${version}";
    sha256 = "sha256-8D6k3pfmrsCX8CTzBGqRay7Z2OpCEy6iz+dVOXt9a94=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qw1AmNeIVrR8cXjjkkT5TaTmB+LRuxKRqes1IzLMDg4=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
