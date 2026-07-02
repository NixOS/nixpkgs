{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hyprls";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w9tUGArzHFy7JurhE9IGfVBTRQi8CCAPfjtT1Q7IX4U=";
  };

  vendorHash = "sha256-thlILlWil618GJzPWkp4u7jmmuexmFtKqnAiZnokP0c=";

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
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprls";
  };
})
