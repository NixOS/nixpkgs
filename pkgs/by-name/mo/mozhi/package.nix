{
  lib,
  buildGoModule,
  fetchFromGitea,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2025-04-14";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "aryak";
    repo = "mozhi";
    rev = "c2c14988c09e6c5fae5a8ac59c07a650f0997a5a";
    hash = "sha256-xJw9BkdKlN1VToKyDlkW8UUZB94gzD9nclNciDmVIkk=";
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
