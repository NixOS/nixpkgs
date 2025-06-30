{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "similarity-ts";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mizchi";
    repo = "similarity-ts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DRW53mnSnPTIlnhI0A9qceMuNXvl32Ct4RUZJ6CR7pc=";
  };

  cargoHash = "sha256-mWXH82jx1hb1SMkDSL2rjc+UjtcRGHHKa7evWdmHcxA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "TypeScript/JavaScript code similarity detection tool";
    homepage = "https://github.com/mizchi/similarity-ts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "similarity-ts";
  };
})
