{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mountain-duck";
  version = "5.0.4.28064";

  src = fetchurl {
    url = "https://dist.mountainduck.io/Mountain%20Duck-${finalAttrs.version}.zip";
    sha256 = "sha256-f69DBNj15dxkNxmFtoxA3d/bSpagpOX7l84fE4a/VWw=";
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
    description = "Mount server and cloud storage as a disk on macOS and Windows";
    homepage = "https://mountainduck.io";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
  };
})
