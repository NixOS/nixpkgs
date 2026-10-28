{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "owntracks-frontend";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "owntracks";
    repo = "frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-omNsCD6sPwPrC+PdyftGDUeZA8nOHkHkRHC+oHFC0eM=";
  };
  npmDepsHash = "sha256-sZkOvffpRoUTbIXpskuVSbX4+k1jiwIbqW4ckBwnEHM=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/owntracks-frontend
    cp -r dist/* $out/share/owntracks-frontend
    cp dist/config/config.example.js $out/share/owntracks-frontend/config/config.js

    runHook postInstall
  '';

  meta = {
    description = "Web interface for OwnTracks";
    homepage = "https://github.com/owntracks/frontend";
    changelog = "https://github.com/owntracks/frontend/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.aionescu ];
    platforms = lib.platforms.linux;
  };
})
