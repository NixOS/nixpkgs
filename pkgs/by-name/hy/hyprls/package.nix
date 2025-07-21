{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "hyprls";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${version}";
    hash = "sha256-cJDDyF44nD/XvxtaGPYCk2MC574HDBHP1ByhVwqatvQ=";
  };

  vendorHash = "sha256-WTdwIAC3gDWgCKlVuOtMyl0ZfdZ9RhlpqUl2S2d65HA=";

  checkFlags = [
    # Not yet implemented
    "-skip=TestHighLevelParse"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP server for Hyprland's configuration language";
    homepage = "https://gwen.works/hyprls";
    changelog = "https://github.com/hyprland-community/hyprls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "hyprls";
  };
}
