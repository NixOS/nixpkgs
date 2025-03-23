{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4-layer-shell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprswitch";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprswitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cmo544QvdacVTHPqmc6er4xnSSc63e6Z71BS0FxSklE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DEifup2oAcqZplx2JoN3hkP1VmxwYVFS8ZqfpR80baA=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    gtk4-layer-shell
  ];

  meta = {
    description = "CLI/GUI that allows switching between windows in Hyprland";
    mainProgram = "hyprswitch";
    homepage = "https://github.com/H3rmt/hyprswitch";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
