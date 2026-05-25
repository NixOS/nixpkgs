{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "os-agent";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "os-agent";
    tag = finalAttrs.version;
    hash = "sha256-Bc/EXVjq0tTxCslKB9zszu10htq/xPgJ5zaiCZ9CHAw=";
  };

  vendorHash = "sha256-PXl/1CW6hQhGFWZDiRo4DNvnaN3CfEIz/fx0a+UVEpo=";

  ldFlags = [
    "-X main.version="
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Daemon allowing to control OS features through D-Bus";
    homepage = "https://github.com/home-assistant/os-agent";
    changelog = "https://github.com/home-assistant/os-agent/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "os-agent";
  };
})
