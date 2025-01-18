{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbip-asn-lite";
  version = "2025-01";

  src = fetchurl {
    url = "https://download.db-ip.com/free/dbip-asn-lite-${finalAttrs.version}.mmdb.gz";
    hash = "sha256-cRlhlP5ml+swBZGiLpVH5s7nvPiHUi7qxM2GajoeK+Y=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preBuild

    gzip -c -d "$src" > dbip-asn-lite.mmdb
    install -Dm444 dbip-asn-lite.mmdb "$out/share/dbip/dbip-asn-lite.mmdb"

    runHook postBuild
  '';

  passthru.mmdb = "${finalAttrs.finalPackage}/share/dbip/dbip-asn-lite.mmdb";

  meta = with lib; {
    description = "Free IP to ASN Lite database by DB-IP";
    homepage = "https://db-ip.com/db/download/ip-to-asn-lite";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ Guanran928 ];
    platforms = platforms.all;
  };
})
