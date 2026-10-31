{
  lib,
  stdenvNoCC,
  cacert,
  nodejs-slim,
  src,
  version,
}:

# the noise suppression assets the frontend build downloads,
# fetched with upstream's script, which also checks their sha256
stdenvNoCC.mkDerivation {
  pname = "sable-next-deepfilternet";
  inherit src version;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cacert
    nodejs-slim
  ];

  installPhase = ''
    runHook preInstall

    node scripts/build/fetch-deepfilternet.mjs
    mv static/deepfilternet3 $out

    runHook postInstall
  '';

  dontFixup = true;

  outputHashMode = "recursive";
  outputHash = "sha256-Qq209UVT88O064TorOgv3a6Id1EAS+owVFRpG85fLH0=";

  meta = {
    description = "DeepFilterNet3 noise suppression assets for Sable";
    homepage = "https://github.com/Rikorose/DeepFilterNet";
    license = with lib.licenses; [
      asl20
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
