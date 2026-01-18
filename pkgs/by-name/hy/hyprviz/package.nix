{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gtk4,
  glib,
  pango,
  pkg-config,
  wrapGAppsHook4,
  hyprland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprviz";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "timasoft";
    repo = "hyprviz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ar1O/Em9AcPPfbuT4xnyOwBX1IClJlFYfdPQbU/5vTk=";
  };

  cargoHash = "sha256-BICF6nZcn/7t5X4Dj18fPD2RpEz7U1Zytt9sfHe7Xnw=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    pango
  ];

  postInstall = ''
    install -Dm644 hyprviz.desktop -t $out/share/applications
  '';

  meta = {
    description = "GUI for configuring Hyprland";
    homepage = "https://github.com/timasoft/hyprviz";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ timasoft ];
    mainProgram = "hyprviz";
    platforms = hyprland.meta.platforms;
    changelog = "https://github.com/timasoft/hyprviz/releases/tag/v${finalAttrs.version}";
  };
})
