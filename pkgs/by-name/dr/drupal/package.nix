{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
  writeScript,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
<<<<<<< HEAD
  version = "11.3.1";
=======
  version = "11.2.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-dVCDIKqLbYHlVwv5wveXG0oHc2g3Zl6J6LG1/e8IIZw=";
  };

  composerNoPlugins = false;
  vendorHash = "sha256-CAntERLTmR9Gf/e+qBLJqqebdXZ0E9k8ifDh75ASoRo=";
=======
    hash = "sha256-mLpdLMacj3ueY8e8YtBA+0D2HOIE2A25Gt3+1E5NqoA=";
  };

  vendorHash = "sha256-s9pUsCJF8PJmiZRqLNEDulGu5fElaN8HVYk+3VtP6CY=";
  composerNoPlugins = false;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    tests = {
      inherit (nixosTests) drupal;
    };
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update xmlstarlet

      set -eu -o pipefail

      version=$(curl -k --silent --globoff "https://updates.drupal.org/release-history/drupal/current" | xmlstarlet sel -t -v "/project/releases/release/tag[not(contains(., 'alpha'))][not(contains(., 'beta'))][not(contains(., '-rc'))]" | grep -m 1 '.')

      nix-update drupal --version $version
    '';
  };

  meta = {
    description = "Drupal CMS";
    license = lib.licenses.mit;
    homepage = "https://drupal.org/";
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
    platforms = php.meta.platforms;
  };
})
