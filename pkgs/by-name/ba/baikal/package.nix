{
  php,
  fetchFromGitHub,
  lib,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "baikal";
  version = "0.12.1";
  src = fetchFromGitHub {
    owner = "sabre-io";
    repo = "Baikal";
    tag = finalAttrs.version;
    hash = "sha256-gouksOoh+QocfyN5FS2Fz0DPjR0IM2dFqvtfTZA7C9Y=";
  };

  # It doesn't provide a composer.lock file, we have to generate manually.
  composerLock = ./composer.lock;
  vendorHash = "sha256-s4ePm6gH7Xid+qkvVqumJrDFz/7HuoCeaeN5bgdQOMY=";

  meta = {
    description = "Lightweight CalDAV+CardDAV server that offers an extensive web interface with easy management of users, address books and calendars";
    homepage = "https://sabre.io/baikal/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ flyingpeakock ];
  };
})
