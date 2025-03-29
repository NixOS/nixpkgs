{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cloudlist";
    tag = "v${version}";
    hash = "sha256-HYCD7mCfIJOijKTPvL5OixZ6zmI/P/+0Agx9bBhxy0Y=";
  };

  vendorHash = "sha256-fZ7l4+No/a8EYqC1nacSyh5fD2QAdzANjTTmbY0d/L4=";

  subPackages = [ "cmd/cloudlist/" ];

  ldflags = [
    "-w"
    "-s"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cloudlist";
  };
}
