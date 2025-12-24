{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
  writeScript,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
  version = "11.2.8";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
    hash = "sha256-y561aeENxRMEFS0i2gMnTtSFfgQwCEM//tdiE3ub3Yc=";
  };

  vendorHash = "sha256-filBjabfUnqL4o1Oh3OC+EoyFrVI6xvFbWEyPZKsZ+Q=";
  composerNoPlugins = false;

  passthru = {
    tests = {
      inherit (nixosTests) drupal;
    };
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update xmlstarlet
      set -eu -o pipefail
      version=$(curl -k --silent --globoff "https://updates.drupal.org/release-history/drupal/current" | xmlstarlet sel -t -v "project/releases/release[1]/tag")
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
