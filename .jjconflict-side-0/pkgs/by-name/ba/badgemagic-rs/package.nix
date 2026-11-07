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
  version = "0.1.0-unstable-2026-06-28";

  src = fetchFromGitHub {
    owner = "fossasia";
    repo = "badgemagic-rs";
    rev = "3ac3c13828f8a111ffe0efb35094d9e3c43d6bf8";
    hash = "sha256-aCPvMD1qNoEQHvkIdyLwxyEBe4lWHOoiUpYYq9sHmm0=";
  };

  cargoHash = "sha256-BjuGanZRCuFjy23JrHQOI6rPMrfTHcj1uvAHkA4/x8c=";

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
    mainProgram = "badgemagic";
  };
}
