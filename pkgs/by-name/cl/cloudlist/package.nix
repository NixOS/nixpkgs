{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cloudlist";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SxrCkaHhlf/+rYcYjuE7UecQWoAhgVy+keRbc0py36k=";
  };

  vendorHash = "sha256-V+2ByID1/2yaxuy7OL21ZBzYgZchszMOblL0bNglcEY=";

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
