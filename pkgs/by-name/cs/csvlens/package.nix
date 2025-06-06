{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    rev = "refs/tags/v${version}";
    hash = "sha256-22IU+TpmmJNCsjrobXe0+0YhssbFMt/j9Vusz69lips=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  cargoHash = "sha256-jLoVuDoarq6ZIWrNw04eyRo+M4jNcZ2zsMWKmZaDPf0=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
