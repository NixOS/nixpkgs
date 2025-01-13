{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "hyprls";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${version}";
    hash = "sha256-PW1AXt8swS86Ucxad8R4exKOJ0Kww23Q1UKBmsKlsc8=";
  };

  vendorHash = "sha256-rG+oGJOABA9ee5nIpC5/U0mMsPhwvVtQvJBlQWfxi5Y=";

  checkFlags = [
    # Not yet implemented
    "-skip=TestHighLevelParse"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP server for Hyprland's configuration language";
    homepage = "https://en.ewen.works/hyprls";
    changelog = "https://github.com/hyprland-community/hyprls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "hyprls";
  };
}
