{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pfetch-rs";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1Br/mO7hisTFxiPJs5vOC+idENYMqfzJEmPBXOFGc58=";
  };

  cargoHash = "sha256-/gYL32kUA4gKTGogMrOghQ3XYFjw3GsDhzynUC/OyXY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.DisplayServices
  ];

  meta = with lib; {
    description = "Rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gobidev ];
    mainProgram = "pfetch";
  };
}
