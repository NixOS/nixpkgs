{
  pname,
  version,
  meta,

  lib,
  fetchurl,
  stdenvNoCC,

  # nativeBuildInputs
  _7zz,
  makeBinaryWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${finalAttrs.version}/OrcaSlicer_Mac_universal_V${finalAttrs.version}.dmg";
    hash = "sha256-4V57sbZiFOxulrFps4gAQXnE9fcF7/za+MgNSZLuA2Y=";
  };

  nativeBuildInputs = [
    # The DMG is APFS, which undmg cannot read.
    _7zz
    makeBinaryWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r OrcaSlicer.app $out/Applications

    makeWrapper $out/Applications/OrcaSlicer.app/Contents/MacOS/OrcaSlicer $out/bin/orca-slicer

    runHook postInstall
  '';

  meta = meta // {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.darwin;
  };
})
