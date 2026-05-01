{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "roave-backward-compatibility-check";
  version = "8.20.0";

  src = fetchFromGitHub {
    owner = "Roave";
    repo = "BackwardCompatibilityCheck";
    tag = finalAttrs.version;
    hash = "sha256-skLTpDak2mgltZpDrNLQXw00omLW/xW5hBPNuX/noSc=";
  };

  vendorHash = "sha256-v8Wv5BK9r3zYst1P0AcpkYCcl0iBvWt+UL2+fEF8Ahw=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/Roave/BackwardCompatibilityCheck/releases/tag/${finalAttrs.version}";
    description = "Tool that can be used to verify BC breaks between two versions of a PHP library";
    homepage = "https://github.com/Roave/BackwardCompatibilityCheck";
    license = lib.licenses.mit;
    mainProgram = "roave-backward-compatibility-check";
    teams = [ lib.teams.php ];
  };
})
