{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-7Y1t/A4k4dgf1Y0OEGPVI3bklXJ/Wuc/IRLSknW/tL8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk_11_0.frameworks.Security ];

  cargoHash = "sha256-ErS0QgI3CbhwgvkUPlR06twKt3Swb+8hlSJv7DO3S70=";

  meta = {
    description = "A simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
