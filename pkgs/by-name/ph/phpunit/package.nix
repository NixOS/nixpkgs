{ lib
, fetchFromGitHub
, nix-update-script
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.3.0";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-c8jooavjabT2RUXHYdRXwQzSD0slHG6ws/83FFL8W5k=";
  };

  vendorHash = "sha256-MjWfMfu3ptJhJubUrP7pC5/o2mVHepRCguPgPzJnGOY=";

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
