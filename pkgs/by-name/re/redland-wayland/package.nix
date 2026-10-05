{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
}:

let
  version = "0.1.0";
in
rustPlatform.buildRustPackage {
  pname = "redland-wayland";
  inherit version;

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "redland";
    tag = "v${version}";
    hash = "sha256-iZtRpxloZzneAQ6+5cW0x1E7Qbx/8i9PqkpOHbCZ4Qk=";
  };

  cargoHash = "sha256-eE+0wvh2g7t3VhqLxQiQ4tu8oSv8w4HIIzRFAf2kxlc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
  ];

  meta = {
    description = "Wayland screen color temperature adjuster with automatic day/night cycle support";
    homepage = "https://github.com/domenkozar/redland";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ domenkozar ];
    mainProgram = "redland";
    platforms = lib.platforms.linux;
  };
}
