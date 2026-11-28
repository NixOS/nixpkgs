{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  unstableGitUpdater,
}:
buildGoModule {
  pname = "mozhi";
  version = "0-unstable-2026-10-15";

  src = fetchFromCodeberg {
    owner = "aryak";
    repo = "mozhi";
    rev = "eed4fb99a2d3a2ea54ed5bf8dc718a32d0785898";
    hash = "sha256-rtA0bA26W/XAfRVKW+VVeWcJOcJjJJqOxAu5XzYTv1g=";
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
