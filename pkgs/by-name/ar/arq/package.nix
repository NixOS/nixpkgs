{
  lib,
  stdenvNoCC,
  fetchurl,
  cpio,
  xar,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arq";
  version = "7.35.1";

  src = fetchurl {
    url = "https://www.arqbackup.com/download/arqbackup/Arq${finalAttrs.version}.pkg";
    hash = "sha256-xkrWH2r3DaxsBBdyu0Wj/qzjJaa9DTZCzEaB/nb2WyY=";
  };

  nativeBuildInputs = [
    cpio
    xar
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    zcat client.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    mkdir -p $out
    cp -R Applications $out
  '';

  dontBuild = true;

  # Arq is notarized
  dontFixup = true;

  meta = {
    changelog = "https://www.arqbackup.com/download/arqbackup/arq7_release_notes.html";
    description = "Multi-cloud backup software for your Macs";
    homepage = "https://www.arqbackup.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ lib.maintainers.Enzime ];
    platforms = lib.platforms.darwin;
  };
})
