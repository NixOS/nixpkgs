{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
  phpunit,
  testers,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
  version = "12.0.7";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-opPnpdqBzCUl+VA6vmMn7WmfS97NFKJUIUKBZCxe+8Y=";
  };

  vendorHash = "sha256-Od+6ChNEnAX9Xsbg41z4RjL0KJWYxTFGfeb6opwvj3A=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = phpunit; };
  };

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = with lib.maintainers; [ onny ] ++ lib.teams.php.members;
  };
})
