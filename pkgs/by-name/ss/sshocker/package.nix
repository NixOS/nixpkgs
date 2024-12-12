{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "sshocker";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q+g48Mm3JsFz9zTsFFypgp7RtQL/03EbVGAwnXLE8fA=";
  };

  vendorHash = "sha256-D4TJ8bIahv05cE6gvF6LmcU2RzV2krjtU8t8wD6R/lY=";

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
