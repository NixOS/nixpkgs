{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i1RxK5NlKNV0mVm4vio557pM2claBTHTo8vmaNQPEvw=";
  };

  cargoHash = "sha256-tOKNGXT3eyUBQnQSD6lsAzYK8rMKU7dCBsZhQYCSw7Q=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
