{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  pango,
  cairo,
  gtk4,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprgui";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = "hyprgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-toHE+N18PGSp0HdR9tcVPYRdfNv20HQfS7U5fHeJ32s=";
  };

  cargoHash = "sha256-Vn059HCHwz0j6ujDVk+GNrHQ7PhqBFb3XfjKLSYlYKg=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    cairo
    pango
    gtk4
  ];

  postInstall = ''
    install -Dm644 -t $out/usr/share/icons hyprgui.png
    install -Dm644 -t $out/usr/share/applications hyprgui.desktop
  '';

  meta = {
    description = "GUI for configuring Hyprland written in Rust";
    homepage = "https://github.com/hyprutils/hyprgui";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fccapria ];
    badPlatforms = lib.platforms.darwin;
    mainProgram = "hyprgui";
  };
}
