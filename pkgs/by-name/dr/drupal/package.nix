{
  lib,
  fetchFromGitLab,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "drupal";
  version = "10.3.1";

  src = fetchFromGitLab {
    domain = "git.drupalcode.org";
    owner = "project";
    repo = "drupal";
    rev = "${finalAttrs.version}";
    hash = "sha256-PvymEvdX1gqe77DIO/5X66YIJrKp9UvTJIQNigaH1W0=";
  };

  vendorHash = "sha256-gdOsXdzB7Ia8mDLjtEH8Dukw6T+OJ9pCUOqZHzVD+rc=";

  meta = {
    description = "Drupal CMS";
    license = lib.licenses.mit;
    homepage = "https://drupal.org/";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = php.meta.platforms;
  };
})
