{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbip-country-lite";
<<<<<<< HEAD
  version = "2025-12";

  src = fetchurl {
    url = "https://download.db-ip.com/free/dbip-country-lite-${finalAttrs.version}.mmdb.gz";
    hash = "sha256-MQ9kJubtM2Iq+gywSz6r7kkdv++BT9qEVPukFV8BQ5Q=";
=======
  version = "2025-11";

  src = fetchurl {
    url = "https://download.db-ip.com/free/dbip-country-lite-${finalAttrs.version}.mmdb.gz";
    hash = "sha256-oOLvy3Le+ybHa3z2AGcmXdjUrfOxhguq8bRkyQh7MnI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    gzip -c -d "$src" > dbip-country-lite.mmdb
    install -Dm444 dbip-country-lite.mmdb "$out/share/dbip/dbip-country-lite.mmdb"

    runHook postInstall
  '';

  passthru.mmdb = "${finalAttrs.finalPackage}/share/dbip/dbip-country-lite.mmdb";

  meta = {
    description = "Free IP to Country Lite database by DB-IP";
    homepage = "https://db-ip.com/db/download/ip-to-country-lite";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [
      nickcao
      Guanran928
    ];
    platforms = lib.platforms.all;
  };
})
