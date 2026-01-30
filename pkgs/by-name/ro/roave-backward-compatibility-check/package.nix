{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "roave-backward-compatibility-check";
  version = "8.17.0";

  src = fetchFromGitHub {
    owner = "Roave";
    repo = "BackwardCompatibilityCheck";
    tag = finalAttrs.version;
    hash = "sha256-+LoAR7pViUnzIICRUUWa7Z5DvSBXo+lr4bjFrTSwq0g=";
  };

  vendorHash = "sha256-q3n3VIxGlIz+xI5h/JNq40CvXFbShXeVoQ5VoIjk21I=";

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
