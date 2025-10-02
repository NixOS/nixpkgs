{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mountain-duck";
  version = "5.0.2.28022";

  src = fetchurl {
    url = "https://dist.mountainduck.io/Mountain%20Duck-${finalAttrs.version}.zip";
    sha256 = "sha256-QismxRiDN6AfzaR8/WZq4O9Wj7knMXhGtIWjkhg/rAQ=";
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
    maintainers = with maintainers; [
      emilytrau
      iedame
    ];
    platforms = platforms.darwin;
  };
})
