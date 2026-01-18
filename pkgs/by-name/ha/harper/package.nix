{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dJd/+9cFT7SVxTg3igJSC3lbOZcVIwjgGtiB+zPVUFU=";
  };

  buildAndTestSubdir = "harper-ls";

  cargoHash = "sha256-cc8TR+AJbnmzIBNykw1gh6nkuPZWZ7GsGdq06THlh1s=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
      ddogfoodd
    ];
    mainProgram = "harper-ls";
  };
})
