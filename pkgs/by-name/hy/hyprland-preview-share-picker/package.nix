{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  gtk4,
  gtk4-layer-shell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-preview-share-picker";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WhySoBad";
    repo = "hyprland-preview-share-picker";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Zztb0soSN/NynWnBIGPuUNRKt2xSx/+f+QpYIPRyRdc=";
  };

  cargoHash = "sha256-AqX9jKj7JLEx1SLefyaWYGbRdk0c3H/NDTIsZy6B6hY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    gtk4
    gtk4-layer-shell
  ];

  strictDeps = true;

  postInstall = ''
    $out/bin/hyprland-preview-share-picker schema > schema.json
    install -Dm0644 schema.json -t $out/share/hyprland-preview-share-picker
  '';

  meta = {
    description = "Alternative share picker for hyprland with window and monitor previews";
    homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprland-preview-share-picker";
  };
})
