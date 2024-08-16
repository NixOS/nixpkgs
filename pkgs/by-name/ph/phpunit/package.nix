{ lib
, fetchFromGitHub
, nix-update-script
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.3.1";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-uTH5LlXabhsu86Te/oNnIrvq88MhAqYbVTyKEaPtTuU=";
  };

  vendorHash = "sha256-hAIuAX3cBxs+mubgS/RlJ+QELvFoV35nAVDmkcaOddY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = with lib.maintainers; [ onny ] ++ lib.teams.php.members;
  };
})
