{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "appcleaner";
  version = "3.6.8";

  src = fetchurl {
    url = "https://freemacsoft.net/downloads/AppCleaner_${finalAttrs.version}.zip";
    hash = "sha256-4BL3KUQkc8IOfM4zSwAYJSHktmcupoGzSTGxgP6z1r4=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Uninstall unwanted apps";
    homepage = "https://freemacsoft.net/appcleaner";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
