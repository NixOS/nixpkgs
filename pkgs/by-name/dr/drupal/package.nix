{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
  writeScript,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
  version = "11.3.13";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
    hash = "sha256-t60EbgN3r9KmSyZcvLtUy+H4eRizqFyI3bLFHH1/ciY=";
  };

  composerNoPlugins = false;
  vendorHash = "sha256-DaKWrdFNHppZm4a8wexfwapSPDhlNL45ftVQ+YSY18s=";

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
