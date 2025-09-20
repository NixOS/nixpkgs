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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "timasoft";
    repo = "hyprviz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-chZtqB74TMblNZy+aGeRsq8wleAyFdCRz7ooLTuf+i0=";
  };

  cargoHash = "sha256-f9A7qOFYmPdNwD109k0Q6vXXO8NJFtAmguvk6Mz3XBw=";

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
