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
  version = "4.64";

  src = fetchurl {
    url = "https://dls.yt.uz/E-IMZO-v${finalAttrs.version}.tar.gz";
    hash = "sha256-ej99PJrO9ufJ8+VlC/HpfvS/bGBtKqUWcsRyiZRlU4c=";
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
    maintainers = with lib.maintainers; [ orzklv ];
  };
})
