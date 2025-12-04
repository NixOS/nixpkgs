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
  vendorHash = "sha256-h86T4GXttASasfQ1BEGldagZiX+T+tem7X0d8gCAjOQ=";

  meta = {
    description = "Lightweight CalDAV+CardDAV server that offers an extensive web interface with easy management of users, address books and calendars";
    homepage = "https://sabre.io/baikal/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wrvsrx ];
    # vendorHash non-reproducible
    broken = true;
  };
})
