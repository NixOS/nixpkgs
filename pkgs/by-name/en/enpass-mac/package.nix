{
  lib,
  stdenvNoCC,
  fetchurl,
  gzip,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "enpass-mac";
  version = "6.11.8.1861";

  src = fetchurl {
    url = "https://dl.enpass.io/stable/mac/package/${finalAttrs.version}/Enpass.pkg";
    hash = "sha256-n0ClsyGTS52ms161CJihIzBI5GjiMIF6HEJ59+jciq8=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [
    gzip
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    gunzip -dc Enpass_temp.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Enpass.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Choose your own safest place to store passwords";
    homepage = "https://www.enpass.io";
    changelog = "https://www.enpass.io/release-notes/macos-website-ver/";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
  };
})
