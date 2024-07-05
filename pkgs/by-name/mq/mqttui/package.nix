{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = "mqttui";
    rev = "refs/tags/v${version}";
    hash = "sha256-aIvT1js+xY1rauZYVCkl71JLfIDjIEGy3W8WdIaTyxY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ratatui-binary-data-widget-0.1.0" = "sha256-4/8ZZag7vpEXnh6wJvZkgGLrOQNJXsnek3gFG/F0+zY=";
    };
  };

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    changelog = "https://github.com/EdJoPaTo/mqttui/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      fab
      sikmir
    ];
    mainProgram = "mqttui";
  };
}
