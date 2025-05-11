{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swaymsg_workspace";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "berezowski";
    repo = "swaymsg_workspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yP8YRcedK4O0tJBeWUqAlsGWwrWWY5QjIYHk+aD/rVc=";
  };

  cargoHash = "sha256-7UiRJ5nPHK2z00EmyIvmj39zYN1I2VVbpcE0R0j3oIY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage Sway Workspaces Utility";
    homepage = "https://github.com/berezowski/swaymsg_workspace";
    changelog = "https://github.com/berezowski/swaymsg_workspace/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "swaymsg_workspace";
    maintainers = with lib.maintainers; [ berezowski ];
    platforms = lib.platforms.linux;
  };
})
