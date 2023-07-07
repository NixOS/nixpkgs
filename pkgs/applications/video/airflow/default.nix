{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "airflow";
  version = "3.3.5";

  src = fetchurl {
    url = "https://cdn.downloads.iocave.net/Airflow/Airflow%20${finalAttrs.version}.zip";
    sha256 = "0nr7023x81v8k71nm1a169a83qllcqvzs525h8vha9cvh2s0q64f";
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
    description = "Watch videos on Chromecast, Apple TV and AirPlay 2 enabled TVs";
    homepage = "https://airflow.app";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
