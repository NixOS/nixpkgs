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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprlauncher";
    rev = "refs/tags/v${version}";
    hash = "sha256-E6/V9p5YIjg3/Svw70GwY1jibkg2xnzdAvmphc0xbQQ=";
  };

  cargoHash = "sha256-gkBpBlBR9Y2dkuqK7X/sxKdS9staFsbHv3Slg9UvP3A=";

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
