{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    rev = "refs/tags/v${version}";
    hash = "sha256-1tFdsSaX6xWG3DuUfbkeHJKO73mUDZcGmGCaGn4Kx24=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  cargoHash = "sha256-rJ9InGfz4HS7Rt8c214LYaIuO2BWAx4UwLBPyTo9GZY=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
