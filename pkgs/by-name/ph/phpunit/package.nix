{ lib
, fetchFromGitHub
, nix-update-script
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.2.0";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-5MWhHMKCy9rrVO1bqyGykWFGw9zI1t6QGVkenvFpGbY=";
  };

  vendorHash = "sha256-w2Yu0T8omr8F7r5nBZOmRJE0LEdGQ3XAdxNZoK1sx1M=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = with lib.maintainers; [ onny patka ] ++ lib.teams.php.members;
  };
})
