{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sshocker";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VFUPRGC6NkBd75X21uAlqDMAYU4Tyo/RFgBsc5D4LMk=";
  };

  vendorHash = "sha256-75eziqi+lgKAA4MTBqVEdf4PEn5J8kk480xsa/2XtqQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lima-vm/sshocker/pkg/version.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tool for SSH, reverse sshfs and port forwarder";
    homepage = "https://github.com/lima-vm/sshocker";
    changelog = "https://github.com/lima-vm/sshocker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sshocker";
  };
})
