{
  cargo,
  fetchFromGitHub,
  gtk-layer-shell,
  gtk3,
  hyprdock,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "hyprdock";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Xetibo";
    repo = "hyprdock";
    tag = "${version}";
    hash = "sha256-j5++YxqeKe3ioMIp7g4n2HBRysBFwbTB9Tnz1ip281U=";
  };

  cargoHash = "sha256-jvJJs06h6yd+M5qxZe+9sboaP6hHmVfxbt9DOds0sw8=";

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
  ];

  passthru = {
    tests.version = testers.testVersion { package = hyprdock; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Docking program for Hyprland with acpid socket";
    homepage = "https://github.com/Xetibo/hyprdock";
    changelog = "https://github.com/Xetibo/hyprdock/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dashietm ];
    mainProgram = "hyprdock";
    platforms = lib.platforms.linux;
  };
}
