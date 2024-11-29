{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbip-country-lite";
  version = "2024-11";

  src = fetchurl {
    url = "https://download.db-ip.com/free/dbip-country-lite-${finalAttrs.version}.mmdb.gz";
    hash = "sha256-Ua4hm0duKHAD/cgtOaDqAYT/4lWsuoIdPnM7K0Lqecw=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preBuild

    gzip -c -d "$src" > dbip-country-lite.mmdb
    install -Dm444 dbip-country-lite.mmdb "$out/share/dbip/dbip-country-lite.mmdb"

    runHook postBuild
  '';

  passthru.mmdb = "${finalAttrs.finalPackage}/share/dbip/dbip-country-lite.mmdb";

  meta = {
    description = "Free IP to Country Lite database by DB-IP";
    homepage = "https://db-ip.com/db/download/ip-to-country-lite";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.all;
  };
})
