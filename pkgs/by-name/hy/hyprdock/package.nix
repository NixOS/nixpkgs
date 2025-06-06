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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Xetibo";
    repo = "hyprdock";
    tag = "${version}";
    hash = "sha256-Ok6m+k8DlA/vlEStib01uuSk13fRTOrNh6Ji/dBL7fE=";
  };

  cargoHash = "sha256-0CAEhMy+zFM4tzRtIBReNyobsA3zDFyHIbV4jcr6i30=";

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
