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
  version = "11.5.1";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-2qcW1MFV23Hp5uKZ+0oKyVPf4Bd0EDeSxpUsVUNO9sI=";
  };

  vendorHash = "sha256-bv0XuwIvb/gbVECImIb4U0zidv9c/jxMv7PXezjlF4A=";

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
