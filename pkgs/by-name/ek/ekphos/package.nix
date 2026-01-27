{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ekphos";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "hanebox";
    repo = "ekphos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sg1HnDByCyPhR0UY8muFYX3p/FEjyx6hMhQ1l2FX/nI=";
  };

  cargoHash = "sha256-zEuMSLQgBnrzAIAJmXaQpig2usN5YbGwpl4e+Vl9Ap4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, fast, terminal-based markdown research tool inspired by Obsidian";
    homepage = "https://www.ekphos.xyz/";
    downloadPage = "https://github.com/hanebox/ekphos";
    changelog = "https://github.com/hanebox/ekphos/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "ekphos";
  };
})
