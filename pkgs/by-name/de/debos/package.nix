{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  glib,
  ostree,
  qemu,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "debos";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "go-debos";
    repo = "debos";
    rev = "e5100810da9a0aa3e0ad4c11c71be73a224e3c60";
    hash = "sha256-WK0C5Qned3z5AbRFfk4RuM8ZrUAmCRstBtgNbZeY3/Y=";
  };

  vendorHash = "sha256-UTXkkjgfi0oI+p1MS2vCnfEHWSW6maLA9xi7p2mroU8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    ostree
    qemu
  ];

  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to create Debian OS images";
    homepage = "https://github.com/go-debos/debos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "debos";
  };
}
