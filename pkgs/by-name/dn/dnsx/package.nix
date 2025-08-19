{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "dnsx";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    tag = "v${version}";
    hash = "sha256-v5GDDA+ubHtUtLvhe0Hwm6l3OqTcIFbdm6HuxxV2zco=";
  };

  vendorHash = "sha256-B9GwQaX/W2xjpIFicfFFGBcopxyhMKZZRKBPcQ/r5Oo=";

  subPackages = [ "cmd/dnsx" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  meta = {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    changelog = "https://github.com/projectdiscovery/dnsx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsx";
  };
}
