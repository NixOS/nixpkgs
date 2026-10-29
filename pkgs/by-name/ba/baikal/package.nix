{
  php,
  fetchFromGitHub,
  lib,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "baikal";
  version = "0.13.0";
  src = fetchFromGitHub {
    owner = "sabre-io";
    repo = "Baikal";
    tag = finalAttrs.version;
    hash = "sha256-GELN9kNTETbNVVRU1YMxmnMugiJhKsx/7jeCq+dxGAU=";
  };

  # It doesn't provide a composer.lock file, we have to generate manually.
  composerLock = ./composer.lock;
  vendorHash = "sha256-OpgZpg9su7iEGdOXbvgnNkr4TAKKut9syMBjyfd8/Bg=";

  meta = {
    description = "Lightweight CalDAV+CardDAV server that offers an extensive web interface with easy management of users, address books and calendars";
    homepage = "https://sabre.io/baikal/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ flyingpeakock ];
  };
})
