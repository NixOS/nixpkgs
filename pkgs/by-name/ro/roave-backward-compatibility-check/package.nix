{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "roave-backward-compatibility-check";
  version = "8.19.0";

  src = fetchFromGitHub {
    owner = "Roave";
    repo = "BackwardCompatibilityCheck";
    tag = finalAttrs.version;
    hash = "sha256-lqOxEhZlx9rFLvWbjoRXd2dqYtaYqarXx5woQZXntAI=";
  };

  vendorHash = "sha256-xsa87iBiUa0jFV0+Myee3Ddo1ICLh3C89Unj9QN0OF4=";

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
