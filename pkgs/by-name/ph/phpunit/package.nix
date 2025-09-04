{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
  phpunit,
  testers,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
  version = "12.3.7";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-v7LXp0TTtGLN0zRZN7GBGlwX7Bb+xNVCN3UYYCt0w1E=";
  };

  vendorHash = "sha256-9cuMWzWvSZy9Djlkk8pw7cOaqEp5060WMGT4FzNSmb4=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = phpunit; };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = with lib.maintainers; [
      onny
      patka
    ];
  };
})
