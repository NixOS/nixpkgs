{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sbstck-dl";
  version = "0.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alexferrari88";
    repo = "sbstck-dl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mwjPFn0n/YmFLKyiyECnVuKJrT7hCzXVat48f99yCNE=";
  };

  vendorHash = "sha256-eNcINIRo/g0LFoEkh1KBob/rQSdkTsSonUogHXwD770=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for downloading Substack newsletters for archival purposes, offline reading, or data analysis";
    homepage = "https://github.com/alexferrari88/sbstck-dl";
    changelog = "https://github.com/alexferrari88/sbstck-dl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ io12 ];
    mainProgram = "sbstck-dl";
  };
})
