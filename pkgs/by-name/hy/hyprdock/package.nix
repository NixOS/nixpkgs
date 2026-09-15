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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Xetibo";
    repo = "hyprdock";
    tag = "${version}";
    hash = "sha256-ZGCzz+2++YxGFaFBV2G2j6MglW/B6+rBrvVy9H/OUJw=";
  };

  cargoHash = "sha256-LEJXqt/Cb6Bp4Gym2v2yIUjqcbTgxVwR8PqaWJE1sx0=";

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
