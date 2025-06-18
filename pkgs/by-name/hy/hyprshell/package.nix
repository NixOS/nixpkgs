{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4-layer-shell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprshell";
  version = "4.2.5";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J6e2VyakM+8V/s5tSK9bEUfFHSGkyVaCCBZ/zQuMEOE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ywTS6c+oxkaTmbVal08T0lrNIkqKJNE0Ovs98Yo6pOM=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    gtk4-layer-shell
  ];

  meta = {
    description = "CLI/GUI that allows switching between windows in Hyprland";
    mainProgram = "hyprshell";
    homepage = "https://github.com/H3rmt/hyprshell";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
