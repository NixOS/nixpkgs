{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gojo";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "gojo";
    tag = "v${version}";
    hash = "sha256-DMFTB5CgJTWf+P9ntgBgzdmcF2qjS9t3iUQ1Rer+Ab4=";
  };

  vendorHash = "sha256-iVAPuc+83WZCs5WAAZIKEExDdwXQqswgso2XRVJB/bE=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "-v" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another Go implementation of jo";
    homepage = "https://github.com/itchyny/gojo";
    changelog = "https://github.com/itchyny/gojo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "gojo";
  };
}
