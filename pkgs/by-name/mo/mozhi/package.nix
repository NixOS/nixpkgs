{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2026-04-09";

  src = fetchFromCodeberg {
    owner = "aryak";
    repo = "mozhi";
    rev = "bab94055f993ee64e2320d7e8d1f974d75f5b6e7";
    hash = "sha256-XAz+YkuRXbSIliXrZTvw6ieRaSHd5b9zZqf/NasEys0=";
  };

  patches = [ ./go-modules.patch ];

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
