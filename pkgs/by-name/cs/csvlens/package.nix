{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    rev = "refs/tags/v${version}";
    hash = "sha256-JlyDw+VL/vpKTvvBlDIwVIovhKJX2pV4UTY47cLR1IE=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  cargoHash = "sha256-PhAEVTlrTF5tj08x8B2vvfEtJadqWtC9rZT8qr0UXB4=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
