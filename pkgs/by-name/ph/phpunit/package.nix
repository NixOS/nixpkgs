{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.1.1";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-aS2mQeE8WnEaTexl8qhhfGyi1MP48s6fjrTXkVLq1LU=";
  };

  vendorHash = "sha256-kjMJCrMG08AXX662GAR5+V6w1+WOv8F9r6ONIOowP8Q=";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
