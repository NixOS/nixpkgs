{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-697LoXu6x8ODQa7tG/NqpSqnLJgM765wBFFnKyul7uI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.Security ];

  cargoHash = "sha256-sxZ4R7QXQSuNFNRuOI/omON6QmQ0DTKQvjHy1BcvXAA=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
