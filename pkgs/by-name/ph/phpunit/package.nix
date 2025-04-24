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
  version = "12.1.3";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-JwEeH3oMiiIa1awLwOrtGfkwN3srhPErkpHaAJ2IFVE=";
  };

  vendorHash = "sha256-3wwv+g9VsNzqgj1m9fea6OhWzbU203I8CPXcJRyWEpg=";

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
    maintainers = with lib.maintainers; [ onny ] ++ lib.teams.php.members;
  };
})
