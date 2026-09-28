{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2026-09-27";

  src = fetchFromCodeberg {
    owner = "aryak";
    repo = "mozhi";
    rev = "ddcd8f3c93b5ff2c67f55dec4a04e4c6ea332579";
    hash = "sha256-CDabkJJA20fEgjpc/Itg3jseoJ3Ms5bYVjtWvpXCEEw=";
  };

  vendorHash = "sha256-ZFbgq/zeBTK6wb5VHHyTNrq8RuNhWTy8PyA1mZcbKYc=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://codeberg.org/aryak/mozhi";
    description = "Alternative-frontend for many translation engines, fork of SimplyTranslate";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "mozhi";
  };
}
