{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paq";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "gregl83";
    repo = "paq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vqJxFmPKQQil0iZOSfmy09/GkI3i1PorztIQPzg0UfE=";
  };

  cargoHash = "sha256-PpwYqwetylyYh6DKn2WiZrMOJmbnkv/cY5u51AVNVno=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash file or directory recursively";
    homepage = "https://github.com/gregl83/paq";
    changelog = "https://github.com/gregl83/paq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "paq";
  };
})
