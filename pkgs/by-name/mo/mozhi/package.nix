{
  lib,
  buildGoModule,
  fetchFromGitea,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2025-06-25";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "aryak";
    repo = "mozhi";
    rev = "88730a992f9bfccf52b6f2a9554ed9a3db697a70";
    hash = "sha256-f2cKgcZ/5A3mSRwfI7h8DsaN15oVnXrg7PejsK8eXGc=";
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
