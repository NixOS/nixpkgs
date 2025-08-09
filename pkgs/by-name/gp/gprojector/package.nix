{
  stdenvNoCC,
  lib,
  fetchzip,
  jre,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  extraJavaArgs ? "-Xms512M -Xmx2000M",
}:

stdenvNoCC.mkDerivation rec {
  pname = "gprojector";
  version = "3.1.0";

  src = fetchzip {
    url = "https://www.giss.nasa.gov/tools/gprojector/download/G.ProjectorJ-${version}.tgz";
    sha256 = "sha256-cMmjyitetXxQzfSBh5ry5tIsLWOnBaaYOD1eQg1IX+w=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "gprojector";
      exec = "gprojector";
      desktopName = "G.Projector";
      comment = meta.description;
      categories = [ "Science" ];
      startupWMClass = "gov-nasa-giss-projector-GProjector";
    })
  ];

  buildInputs = [ jre ];
  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r $src/jars $out/share/java
    makeWrapper ${jre}/bin/java $out/bin/gprojector --add-flags "-jar $out/share/java/G.Projector.jar" --add-flags "${extraJavaArgs}"
    runHook postInstall
  '';

  meta = {
    description = "G.Projector transforms an input map image into any of about 200 global and regional map projections";
    homepage = "https://www.giss.nasa.gov/tools/gprojector/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ pentane ];
    license = lib.licenses.unfree;
    inherit (jre.meta) platforms;
  };
}
