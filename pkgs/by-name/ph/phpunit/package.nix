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
  version = "12.2.2";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-CcN+2EuniPvCB0WXKI4IOOWUfguOlVq7lSdYzBNccfs=";
  };

  vendorHash = "sha256-GLQNRoxwdGm4MWaxyqM4Va5qZgEXFO4AB8IMQL2TAws=";

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
    maintainers = with lib.maintainers; [ onny ];
    teams = [ lib.teams.php ];
  };
})
