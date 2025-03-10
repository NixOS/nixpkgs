{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "rlama";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "dontizi";
    repo = "rlama";
    tag = "v${version}";
    hash = "sha256-4/knQz0uVdAg6H83c83Ii1KHAbpnCYa7z/C+vnCVlLk=";
  };

  vendorHash = "sha256-eKeUhS2puz6ALb+cQKl7+DGvm9Cl+miZAHX0imf9wdg=";

  nativeBuildInputs = [
    pkg-config
  ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "RLAMA - Retrieval-Augmented Language Model Adapter";
    homepage = "https://github.com/dontizi/rlama";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rlama";
  };
}
