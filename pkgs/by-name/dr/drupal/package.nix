{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
  writeScript,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
  version = "11.4.5";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
    hash = "sha256-G5Kk4EVpMXV9H9LFvRJnh1Y1rqL6fA18WoTJs+lRV10=";
  };

  composerNoPlugins = false;
  vendorHash = "sha256-P6egjq0lffLGDv3hDJOTvW8Qs3vqR9cT33oURKTfRcQ=";

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
