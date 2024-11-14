{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  gtk4,
  gtk4-layer-shell,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprlauncher";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprlauncher";
    rev = "refs/tags/v${version}";
    hash = "sha256-+CFMGWK7W8BWIY2Xg4P7VLYQ7wQmmmjGSM5Rzq8yMSY=";
  };

  cargoHash = "sha256-epvUpsWkkJqWuUjsbHQaHMcBkDc06ke56I/5/QEag/g=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    pango
    gtk4
    gtk4-layer-shell
  ];

  meta = {
    description = "GUI for launching applications, written in Rust";
    homepage = "https://github.com/hyprutils/hyprlauncher";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ arminius-smh ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprlauncher";
  };
}
