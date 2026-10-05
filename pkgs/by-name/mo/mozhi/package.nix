{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2026-08-30";

  src = fetchFromCodeberg {
    owner = "aryak";
    repo = "mozhi";
    rev = "ad53459f38e995eabdb5fd10352b0a2f57c278a2";
    hash = "sha256-Zn+3McD+uGO+Vk88gbq7sqU7OahWZmtwuHxwvMIM/gw=";
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
