{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cloudlist";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tm2gqRZxfeu5gOndVeeFU9HCePpXyx/G73VzVuJRRzY=";
  };

  vendorHash = "sha256-LkjJrxrK1N+6v6ilMT68lu21B3NemxdquMIA5e8r1a0=";

  subPackages = [ "cmd/cloudlist/" ];

  ldflags = [
    "-w"
    "-s"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudlist";
  };
})
