{ lib
, fetchFromGitHub
, nix-update-script
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "11.1.3";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-Wq2k44WpUhDhSyIx8ofn/jUR7FS3zn2CCe4OiFKHXEA=";
  };

  vendorHash = "sha256-kjMJCrMG08AXX662GAR5+V6w1+WOv8F9r6ONIOowP8Q=";

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
