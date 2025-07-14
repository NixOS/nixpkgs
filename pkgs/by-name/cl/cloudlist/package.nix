{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    tag = "v${version}";
    hash = "sha256-xCGGyPfD6cQgVTowh8ZO9Ak3xH5Hct51Vm18FJWLF1E=";
  };

  vendorHash = "sha256-PW9Yu8d5PPIL6cc692N8e5qO73drEgfu7JrVeihggcs=";

  subPackages = [ "cmd/cloudlist/" ];

  ldflags = [
    "-w"
    "-s"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudlist";
  };
}
