{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2026-06-11";

  src = fetchFromCodeberg {
    owner = "aryak";
    repo = "mozhi";
    rev = "095c73f04bc24f51dcb4a0155a5f10f87f768a8c";
    hash = "sha256-c792IEMToojcLgsCpMizsszVwymZldvRVP9eWuEO5sY=";
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
