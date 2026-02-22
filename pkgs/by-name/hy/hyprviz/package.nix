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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "timasoft";
    repo = "hyprviz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5w7+fkf2oB0x5N6xlKjSPbgsB7Ifr1NWW8qWDmGyFwU=";
  };

  cargoHash = "sha256-+8MKYruPjCTooiY7pxwz5oqIpk4ZidugPrVlMZ1yMI0=";

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
