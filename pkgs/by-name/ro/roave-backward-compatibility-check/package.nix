{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "roave-backward-compatibility-check";
  version = "8.14.0";

  src = fetchFromGitHub {
    owner = "Roave";
    repo = "BackwardCompatibilityCheck";
    tag = finalAttrs.version;
    hash = "sha256-4rhIaPdyyLiIhVYC4KNKbPAbVsHKnK6BOsebFjmmDeI=";
  };

  vendorHash = "sha256-uZqstfVp5uY7Sec32XLK7RvuUtP8Hj21W7tayhhuf2g=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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
