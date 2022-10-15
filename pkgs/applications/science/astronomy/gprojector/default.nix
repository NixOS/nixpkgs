{ stdenvNoCC
, lib
, fetchzip
, jre
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, extraJavaArgs ? "-Xms512M -Xmx2000M"
}:

stdenvNoCC.mkDerivation rec {
  pname = "gprojector";
  version = "3.0.4";

  src = fetchzip {
    url = "https://www.giss.nasa.gov/tools/gprojector/download/G.ProjectorJ-${version}.tgz";
    sha256 = "sha256-6EixVNRgYnuY9INb7gAyBzo125DhPEUPD+pGxjzmhy8=";
  };

  desktopItems = [ (makeDesktopItem {
    name = "gprojector";
    exec = "gprojector";
    desktopName = "G.Projector";
    comment = meta.description;
    categories = [ "Science" ];
    startupWMClass = "gov-nasa-giss-projector-GProjector";
  }) ];

  buildInputs = [ jre ];
  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

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
    maintainers = with lib.maintainers; [ alyaeanyx ];
    license = lib.licenses.unfree;
    inherit (jre.meta) platforms;
  };
}
