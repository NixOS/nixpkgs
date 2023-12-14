{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "leaf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "IogaMaster";
    repo = "leaf";
    rev = "v${version}";
    hash = "sha256-FbvXH0DXA+XvZuWZ7iJi4PqgoPv5qy5SWdXFlfBSmlM=";
  };

  cargoHash = "sha256-CsO3JzL5IqxGpj9EbbuDmmarzYpLFmmekX0W9mAQSzI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "A simple system fetch written in rust";
    homepage = "https://github.com/IogaMaster/leaf";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "leaf";
  };
}
