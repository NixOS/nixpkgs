{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ahoy";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ahoy-cli";
    repo = "ahoy";
    tag = "v${version}";
    hash = "sha256-xwjfY9HudxVz3xEEyRPtWysbojtan56ABBL3KgG0J/8=";
  };

  # vendor folder exists
  vendorHash = null;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Create self-documenting cli programs from YAML files";
    homepage = "https://github.com/ahoy-cli/ahoy";
    changelog = "https://github.com/ahoy-cli/ahoy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "ahoy";
  };
}
