{
  lib,
  fetchFromGitLab,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "drupal";
  version = "10.3.0";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    rev = "${finalAttrs.version}";
    hash = "sha256-/8ta6NjODynctAHx2l92m1ZubiRpzKXu/TkBFn1owBs=";
  };

  vendorHash = "sha256-23HSGlcr+9qzWxiTjXzDtLtVb3jxd2WAfL03Tg6IxS0=";

  meta = {
    description = "Drupal CMS";
    license = lib.licenses.mit;
    homepage = "https://drupal.org/";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = php.meta.platforms;
  };
})
