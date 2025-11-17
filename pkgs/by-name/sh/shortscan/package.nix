{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "shortscan";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "bitquark";
    repo = "shortscan";
    tag = "v${version}";
    hash = "sha256-pJKhaeax1aHSR8OT6jp/Pe5bMBA7ASLF1MMlzd4Ppag=";
  };

  vendorHash = "sha256-KBQP4fFs6P6I+ch1n4Raeu1or2wWhFeTv1b3DpIWAP8=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "IIS short filename enumeration tool";
    homepage = "https://github.com/bitquark/shortscan";
    changelog = "https://github.com/bitquark/shortscan/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "shortscan";
  };
}
