{
  lib,
  php82,
  fetchFromGitHub,
  versionCheckHook,
}:

php82.buildComposerProject2 (finalAttrs: {
  pname = "robo";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    tag = finalAttrs.version;
    hash = "sha256-bAT4jHvqWeYcACeyGtBwVBA2Rz+AvkZcUGLDwSf+fLg=";
  };

  vendorHash = "sha256-Rg8WTZUnWA4bemNmE7hxFwfnlMtYyPkeltAQEWJ2VDU=";

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
