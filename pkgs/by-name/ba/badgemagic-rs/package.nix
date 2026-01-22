{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  systemdLibs,
}:

rustPlatform.buildRustPackage {
  pname = "badgemagic-rs";
  version = "0.1.0-unstable-2025-07-15";

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "badgemagic-rs";
    rev = "5d745ab8fda418204425f3df0e969a98bf479f2d";
    hash = "sha256-IyPUPNbXkLNz/cuzVuzrD2iCE1ddeO3xkAOKhbrNU+k=";
  };

  cargoHash = "sha256-jT/pJLqdWGTpQFlnhuZo1FLqRQJWXCD2tuDB2AEyNPQ=";

  buildFeatures = [ "cli" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    systemdLibs
  ];

  meta = {
    description = "Badge Magic in Rust";
    homepage = "https://github.com/fossasia/badgemagic-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "badgemagic-rs";
  };
}
