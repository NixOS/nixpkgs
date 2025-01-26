{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "idb-companion";
  version = "1.1.8";

  src = fetchurl {
    url = "https://github.com/facebook/idb/releases/download/v${finalAttrs.version}/idb-companion.universal.tar.gz";
    hash = "sha256-O3LMappbGiKhiCBahAkNOilDR6hGGA79dVzxo8hI4+c=";
  };

  sourceRoot = "idb-companion.universal";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful command line tool for automating iOS simulators and devices";
    homepage = "https://github.com/facebook/idb";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "idb_companion";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ siddarthkay ];
  };
})
