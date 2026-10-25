{
  fetchzip,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yamnet_classification_v1";
  version = "0-unstable";

  src = fetchzip {
    url = "https://www.kaggle.com/api/v1/models/google/yamnet/tfLite/classification-tflite/1/download";
    extension = "tar.gz";
    hash = "sha256-FRL0lpbjgAV7HlaZIR1Hf/hr1bcfSMSeYdeGzMYpDf0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv 1.tflite $out/yamnet_classification_v1.tflite
    runHook postInstall
  '';

  passthru.model = "${finalAttrs.finalPackage}/${finalAttrs.pname}.tflite";

  meta = {
    homepage = "https://www.kaggle.com/models/google/yamnet/tfLite/classification-tflite";
    license = lib.licenses.asl20;
  };
})
