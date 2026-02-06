{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2026-01-10";

  src = fetchFromCodeberg {
    owner = "aryak";
    repo = "mozhi";
    rev = "6b3f675b8d4c8fb852e88f0696d0c4d72516e618";
    hash = "sha256-O+heptNxkckcYxUi1QZUBun0F3zquGp5gPVsuWThajQ=";
  };

  vendorHash = "sha256-PiduR6mEATCKMi1lvKx4lpuSvNAyMhdeI/pRrsgGNx8=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://codeberg.org/aryak/mozhi";
    description = "Alternative-frontend for many translation engines, fork of SimplyTranslate";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "mozhi";
  };
}
