{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-k0ox4/Djpu6DoWGzQdo7wYSZHSeaCtNVuEwK3bhBgQQ=";
  };

  vendorHash = "sha256-2rG0ERgI5oVW3MuU8yFwgssoWX6zwUwXpro2IVkX7ac=";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
