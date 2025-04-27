{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbip-city-lite";
  version = "2025-03";

  src = fetchurl {
    url = "https://download.db-ip.com/free/dbip-city-lite-${finalAttrs.version}.mmdb.gz";
    hash = "sha256-lmpIbG3Riv3Sm4HF3UOJoTih1rGZK4j5Mvi3j2U1a3g=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preBuild

    gzip -c -d "$src" > dbip-city-lite.mmdb
    install -Dm444 dbip-city-lite.mmdb "$out/share/dbip/dbip-city-lite.mmdb"

    runHook postBuild
  '';

  passthru.mmdb = "${finalAttrs.finalPackage}/share/dbip/dbip-city-lite.mmdb";

  meta = {
    description = "Free IP to City Lite database by DB-IP";
    homepage = "https://db-ip.com/db/download/ip-to-city-lite";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.all;
  };
})
