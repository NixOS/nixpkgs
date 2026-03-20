{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "os-agent";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "os-agent";
    tag = finalAttrs.version;
    hash = "sha256-x0bVY476Gm5D1drRmyszdshrO0Vi/baDsG3ulysu0Kg=";
  };

  vendorHash = "sha256-9boWe/mvJ/C/I8B7b4hJgz2dEDgpKCNTE/8pVAsNTxg=";

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
