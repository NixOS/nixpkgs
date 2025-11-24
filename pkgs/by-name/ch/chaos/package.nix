{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    tag = "v${version}";
    hash = "sha256-YjwxInBEPgovSk5EZzpeNhp4/FRWf6prZnNqcyyFFJg=";
  };

  vendorHash = "sha256-c5J2cTzyb7CiBlS4vS3PdRhr6DhIvXE2lt40u0s6G0k=";

  subPackages = [ "cmd/chaos/" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool to communicate with Chaos DNS API";
    homepage = "https://github.com/projectdiscovery/chaos-client";
    changelog = "https://github.com/projectdiscovery/chaos-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "chaos";
  };
}
