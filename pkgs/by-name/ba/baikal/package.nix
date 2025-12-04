{
  php,
  fetchFromGitHub,
  lib,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "baikal";
  version = "0.11.1";
  src = fetchFromGitHub {
    owner = "sabre-io";
    repo = "Baikal";
    tag = finalAttrs.version;
    hash = "sha256-+rOaPgVD5q2LoTXG3PM2x9EyOExt7CRPU+HQouwgaqI=";
  };

  # It doesn't provide a composer.lock file, we have to generate manually.
  composerLock = ./composer.lock;
  vendorHash = "sha256-QE8i59MP24BdZjzzgQVfTuhL4v9l60KxpKj4+lkdomE=";

  meta = {
    description = "Lightweight CalDAV+CardDAV server that offers an extensive web interface with easy management of users, address books and calendars";
    homepage = "https://sabre.io/baikal/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ flyingpeakock ];
  };
})
