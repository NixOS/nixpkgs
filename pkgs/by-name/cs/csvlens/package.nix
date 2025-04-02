{
  lib,
  stdenv,
  darwin,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    tag = "v${version}";
    hash = "sha256-kyUfpZaOpLP8nGrXH8t9cOutXFkZsmZnPmIu3t6uaWU=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-lr1pqFodqgsKHRFGonXj0nG4elomiSMETulBdCLMR3w=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
