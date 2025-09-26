{
  lib,
  buildGoModule,
  fetchFromGitea,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2025-09-19";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "aryak";
    repo = "mozhi";
    rev = "67f216b3fa9edb3b3ec995a4a6fb6777ea934177";
    hash = "sha256-fQkOyfuBbRLvCzwv7kT1AEJUAWQshWOZDTYfp7plkag=";
  };

  vendorHash = "sha256-ptwP+ZuuzxRpIuNDoXnAML1KYEh9zTBcOs9YTI8z63A=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://codeberg.org/aryak/mozhi";
    description = "Alternative-frontend for many translation engines, fork of SimplyTranslate";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "mozhi";
  };
}
