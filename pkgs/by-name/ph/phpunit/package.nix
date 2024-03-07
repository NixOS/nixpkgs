{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.0.4";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-ucUDeiqz8QkCsKM/SfHVjJSnfs0TRaV04CTKepSzyo0=";
  };

  vendorHash = "sha256-0jbSUIT4Eh1lWu11REgE4ilGlw1zuawXeKCPBHnoxdk=";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
