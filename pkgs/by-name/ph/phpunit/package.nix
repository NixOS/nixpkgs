{ lib
, fetchFromGitHub
, nix-update-script
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.2.7";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-s/zfTW8a+E/FOuHg+oSpVZdxBdfIVL0RmvBBcI6zB9Y=";
  };

  vendorHash = "sha256-Gjii3m8wWmZbozKnJW/n9+wQUupemIU8XjmlCuTtfxU=";

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
