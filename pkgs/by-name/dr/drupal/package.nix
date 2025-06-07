{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
  version = "10.4.8";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
    hash = "sha256-PC7cxyQZpn4H1QB/+mUgEDj2YFSaol2sV7lCHi8IK/0=";
  };

  vendorHash = "sha256-5d7OAdn8VUmXYKu/XMwIDnnTStrm2Xf1ud9Uz1DLo+Q=";
  composerNoPlugins = false;

  passthru = {
    tests = {
      inherit (nixosTests) drupal;
    };
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
