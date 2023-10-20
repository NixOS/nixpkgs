{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-gtwS7e28vVIF1OfaAktNlI7Lml5K+/MXVxJo8+knIsg=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.Security ];

  cargoHash = "sha256-G1687/blL2U+lRGAM6QCwMJRptrku4qW8vG3TmLK+hk=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
