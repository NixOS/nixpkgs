{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "10.5.1";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-uYSVzKLefcBMqfrHaF6pg4gohAeb6LVg8QGaTS8jwfE=";
  };

  vendorHash = "sha256-uUdgz3ZZ+3nU07pUC1sdkNgU1b1beo3sS/yySUzdZwU=";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
