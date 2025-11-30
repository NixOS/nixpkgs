{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "sshocker";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    tag = "v${version}";
    hash = "sha256-7s5jPMt6q7RUXxwA7rwVXhWGRrwfMc/EcEQxicwEHjs=";
  };

  vendorHash = "sha256-FGaZTE8CCZ16ozsZr5MUFNkEy8+nkBYXH55n5TJG4Bg=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lima-vm/sshocker/pkg/version.Version=${version}"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool for SSH, reverse sshfs and port forwarder";
    homepage = "https://github.com/lima-vm/sshocker";
    changelog = "https://github.com/lima-vm/sshocker/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sshocker";
  };
}
