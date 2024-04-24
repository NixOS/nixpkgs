{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    rev = "refs/tags/v${version}";
    hash = "sha256-4lKiqojBF8mqAp56eTDfJcK276IzEDLA3pORKIZpC94=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  cargoHash = "sha256-EzM7qGor/B17N4KDTsQzgiV4pgXE2D47RZcrmKVkPu8=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
