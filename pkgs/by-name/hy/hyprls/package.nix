{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hyprls";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5JOJ93XPJ3hFThpLQmQ+EL0wkn+nrq15pwGhZrhc2h0=";
  };

  vendorHash = "sha256-xSDIGlvJjr2IF04X3uoiVvHN2qgcBSNSDHIkTUxW9eM=";

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
