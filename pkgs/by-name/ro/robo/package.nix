{
  lib,
  php82,
  fetchFromGitHub,
  versionCheckHook,
}:

php82.buildComposerProject2 (finalAttrs: {
  pname = "robo";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    tag = finalAttrs.version;
    hash = "sha256-OYuP56KlS9onuYcy9xL0XrH9hqf/njwVUju1pDyRgKM=";
  };

  vendorHash = "sha256-HGVeoy6duUfRLtx05mlZc3wCOeRTzNXJXxXurZDzZFs=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/consolidation/robo/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Modern task runner for PHP";
    homepage = "https://github.com/consolidation/robo";
    license = lib.licenses.mit;
    mainProgram = "robo";
    maintainers = [ ];
  };
})
