{
  lib,
  stdenvNoCC,
  fetchurl,
  jre8,
  curl,
  ccid,
  pcsclite,
  pcsc-tools,
  writeShellScript,
}:
let
  exec = writeShellScript "e-imzo" ''
    cd "$(dirname "$0")/../lib/e-imzo"

    ${jre8}/bin/java -Dsun.security.smartcardio.library=${pcsclite.lib}/lib/libpcsclite.${stdenvNoCC.hostPlatform.extensions.sharedLibrary} -jar E-IMZO.jar

    exit 0
  '';
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "e-imzo";
  version = "5.00";

  src = fetchurl {
    url = "https://cdn.xinux.uz/e-imzo/E-IMZO-v${finalAttrs.version}.tar.gz";
    hash = "sha256-jPAZu98prkC4NQlfA8/kJuw9qdCrSSSyzySSWPlIXpY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/e-imzo
    install -m 755 -d $out/lib/e-imzo
    install -m 644 ./E-IMZO.jar $out/lib/e-imzo/
    install -m 644 ./E-IMZO.pem $out/lib/e-imzo/
    install -m 644 ./truststore.jks $out/lib/e-imzo/
    cp -r ./lib $out/lib/e-imzo/

    install -m 755 "${exec}" $out/bin/e-imzo

    runHook postInstall
  '';

  meta = {
    description = "For uzbek state web identity proving & key signing";
    mainProgram = "e-imzo";
    platforms = with lib.platforms; linux ++ darwin;
    homepage = "https://e-imzo.soliq.uz";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    teams = [ lib.teams.uzinfocom ];
  };
})
