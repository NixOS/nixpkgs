{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "paq";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "gregl83";
    repo = "paq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oB805M37oLLV2Nttchwzd6V2AUqCo8JFhj6Mfg/JfH0=";
  };

  cargoHash = "sha256-ziYcaUGYxp+gR5v/yxQElNGLugo3bJtjVwCaHiFkMpw=";

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
