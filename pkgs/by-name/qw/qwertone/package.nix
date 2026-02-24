{
  lib,
  rustPlatform,
  fetchFromGitLab,
  wrapGAppsHook3,
  pkg-config,
  alsa-lib,
  atk,
  gtk3,
}:

rustPlatform.buildRustPackage rec {
  pname = "qwertone";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "azymohliad";
    repo = "qwertone";
    tag = "v${version}";
    hash = "sha256-GD7iFDAaS6D7DGPvK+Cof4rVbUwPX9aCI1jfc0XTxn8=";
  };

  cargoHash = "sha256-5hrjmX+eUPrj48Ii1YHPZFPMvynowSwSArcNnUOw4hc=";

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    atk
    gtk3
  ];

  meta = {
    description = "Simple music synthesizer app based on usual qwerty-keyboard for input";
    mainProgram = "qwertone";
    homepage = "https://gitlab.com/azymohliad/qwertone";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
  };
}
