{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
  writeScript,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
  version = "11.2.1";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
    hash = "sha256-GlQvgI3dmRSHtNky0ZL4Y4VWIaUrO+EjPwnkkF9DJDQ=";
  };

  vendorHash = "sha256-2XqYxuIlnXzyvOYtY67H1hOuuFjApi0H5VV74j/RJzI=";
  composerNoPlugins = false;

  passthru = {
    tests = {
      inherit (nixosTests) drupal;
    };
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts xmlstarlet
      set -eu -o pipefail
      version=$(curl -k --silent --globoff "https://updates.drupal.org/release-history/drupal/current" | xmlstarlet sel -t -v "project/releases/release[1]/tag")
      update-source-version drupal $version --file=./pkgs/by-name/dr/drupal/package.nix
    '';
  };

  meta = {
    description = "Drupal CMS";
    license = lib.licenses.mit;
    homepage = "https://drupal.org/";
    maintainers = with lib.maintainers; [
      drupol
      OulipianSummer
    ];
    platforms = php.meta.platforms;
  };
})
