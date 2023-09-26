{ lib
, php
, fetchFromGitHub
}:

php.buildComposerProject (finalAttrs: {
  pname = "baikal";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "sabre-io";
    repo = "baikal";
    rev = finalAttrs.version;
    hash = "sha256-uX2vkBw3qBfkcHdGt8lPEHnSb8GMutRzCtmlL7e3igs=";
  };

  vendorHash = "sha256-cgl6vr00y8V3lYt9OuHyCs13o3z2EKAaO/YgrTWFtwI=";

  composerLock = ./composer.lock;

  meta = with lib; {
    description = "a lightweight CalDAV+CardDAV server. It offers an extensive web interface with easy management of users, address books and calendars";
    homepage = "https://sabre.io/baikal/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ janik ];
  };
})
