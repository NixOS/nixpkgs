{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hyprls";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-020bEXaFKZ74dJF5keIXMyRf/MQj0eKNYZXHajHgKUI=";
  };

  vendorHash = "sha256-av3IZlfb09j6Dakc9lm8rPr85I/+pscjhEcZD04scUo=";

  checkFlags = [
    # Not yet implemented
    "-skip=TestHighLevelParse"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP server for Hyprland's configuration language";
    homepage = "https://gwen.works/hyprls";
    changelog = "https://github.com/hyprland-community/hyprls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "hyprls";
  };
})
