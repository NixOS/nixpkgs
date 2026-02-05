{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "install-nothing";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "buyukakyuz";
    repo = "install-nothing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Raz6TJ7MqOi4bQE6nN7JJVCVlGZ9v7OZRfaeL+UMx2A=";
  };

  cargoHash = "sha256-jNjAzMrRUT3MdD7OMfCB0+dKRGPQsT9kBIweTOhJCOc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal application that simulates installing things but doesn't actually install anything";
    homepage = "https://github.com/buyukakyuz/install-nothing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "install-nothing";
  };
})
