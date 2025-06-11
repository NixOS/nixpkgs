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
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprswitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSTeNVHkfUS6qlN1pWWpMVeT+jjacithCHOpOhRKanA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NzyK46zmHWxFaTS9mzFC7kBUMys1sjmcWaZUcwLusEk=";

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
    homepage = "https://github.com/H3rmt/hyprswitch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
