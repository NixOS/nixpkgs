{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "bunbun";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "devraza";
    repo = "bunbun";
    rev = "refs/tags/v${version}";
    hash = "sha256-Cvg3zT2RFyqhzwkKs0bi/2Q7HlX7rirGJrFDDmmVQU4=";
  };

  cargoHash = "sha256-dpMiOzstQCKwOquZQuqCT1JaiK9gsPMSx+ICWezoRxI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Simple and adorable sysinfo utility written in Rust";
    homepage = "https://github.com/devraza/bunbun";
    changelog = "https://github.com/devraza/bunbun/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "bunbun";
  };
}
