{
  lib,
  fetchFromGitLab,
  php,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "drupal";
  version = "11.1.7";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    tag = finalAttrs.version;
    hash = "sha256-jf28r44VDP9MzShoJMFD+6xSUcKBRGYJ1/ruQ3nGTRE=";
  };

  vendorHash = "sha256-LUZTf/Zn8p+V2K1LjhvrgaGBiTcSmGRsG1t9vXUcbeY=";
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
