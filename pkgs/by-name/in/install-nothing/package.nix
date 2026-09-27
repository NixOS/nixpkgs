{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "install-nothing";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "buyukakyuz";
    repo = "install-nothing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ULTB17wNa8IaQbeK0EeQOsSwtMn2PdLOmfrd0fiVeCM=";
  };

  cargoHash = "sha256-iERbRcbFG2RbsTxyvwwgl92trbNo6DjJu9UK75Co15c=";

  doInstallCheck = false; # https://github.com/buyukakyuz/install-nothing/issues/20
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal application that simulates installing things but doesn't actually install anything";
    homepage = "https://github.com/buyukakyuz/install-nothing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "install-nothing";
  };
})
