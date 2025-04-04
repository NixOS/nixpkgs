{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "sshocker";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    tag = "v${version}";
    hash = "sha256-ehsQ/Z1LCSpnvIvABLCIR2aLG4DK33VJ9gidoSEoeqw=";
  };

  vendorHash = "sha256-9le1ETAdMZ1s7Hl2STz76/9eU0YkI4yNM/PZVXOwndQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lima-vm/sshocker/pkg/version.Version=${version}"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Tool for SSH, reverse sshfs and port forwarder";
    homepage = "https://github.com/lima-vm/sshocker";
    changelog = "https://github.com/lima-vm/sshocker/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sshocker";
  };
}
