{
  php,
  fetchFromGitHub,
  lib,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "baikal";
  version = "0.10.1";
  src = fetchFromGitHub {
    owner = "sabre-io";
    repo = "Baikal";
    tag = finalAttrs.version;
    hash = "sha256-YQQwTdwfHQZdUhO5HbScj/Bl8ype7TtPI3lHjvz2k04=";
  };
  # It doesn't provide a composer.lock file, we have to generate manually.
  composerLock = ./composer.lock;
  vendorHash = "sha256-dYg7cULL4gquR5EenA0lD9ZC9Ge4qNwFFDNhELKgSso=";

  meta = {
    description = "Lightweight CalDAV+CardDAV server that offers an extensive web interface with easy management of users, address books and calendars";
    homepage = "https://sabre.io/baikal/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wrvsrx ];
  };
})
