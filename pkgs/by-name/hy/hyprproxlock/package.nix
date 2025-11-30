{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprproxlock";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Da4ndo";
    repo = "hyprproxlock";
    tag = "${version}";
    hash = "sha256-EoMxYMQBRP1fDfUorrkrgKDrVI88Ctusp2+1a7tnSU0=";
  };

  cargoHash = "sha256-rBZ3acHStmUzEU+lsFhNYvLVPeeZe6P+4OHyxHRe4CU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A proximity-based daemon for Hyprland that triggers screen locking and unlocking through hyprlock based on Bluetooth device proximity.";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprproxlock";
  };
}
