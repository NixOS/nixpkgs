{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gogcli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "gogcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DXRw5jf/5fC8rgwLIy5m9qkxy3zQNrUpVG5C0RV7zKM=";
  };

  vendorHash = "sha256-nig3GI7eM1XRtIoAh1qH+9PxPPGynl01dCZ2ppyhmzU=";

  subPackages = [ "cmd/gog" ];

  ldflags = [
    "-s"
    "-w"
  ];

  # integration tests require network access and Google credentials
  checkFlags = [
    "-skip=^TestIntegration"
  ];

  excludedPackages = [ "internal/integration" ];

  meta = {
    description = "Fast, script-friendly CLI for Google Workspace services";
    homepage = "https://github.com/steipete/gogcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chansuke ];
    mainProgram = "gog";
  };
})
