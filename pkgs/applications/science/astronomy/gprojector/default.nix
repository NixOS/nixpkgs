{ stdenv
, lib
, fetchzip
, jre
, makeDesktopItem
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "gprojector";
  version = "3.0.2";

  src = fetchzip {
    url = "https://www.giss.nasa.gov/tools/gprojector/download/G.ProjectorJ-${version}.tgz";
    sha256 = "sha256-IvGZOYt2d8aWtlAJJzVrwkqOOhaUHUmEDlMeD/0NdwU=";
  };

  desktopItem = makeDesktopItem {
    name = "gprojector";
    exec = "gprojector";
    desktopName = "G.Projector";
    comment = meta.description;
    categories = "Science;";
    extraEntries = "StartupWMClass = gov-nasa-giss-projector-GProjector";
  };

  buildInputs = [ jre ];
  nativeBuildInputs = [ makeWrapper desktopItem ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r $src/jars $out/share/java
    cp -r $desktopItem/share/applications $out/share/applications
    makeWrapper ${jre}/bin/java $out/bin/gprojector --add-flags "-Xms512M -Xmx2000M -jar $out/share/java/G.Projector.jar"
    runHook postInstall
  '';

  meta = {
    description = "G.Projector transforms an input map image into any of about 200 global and regional map projections";
    homepage = "https://www.giss.nasa.gov/tools/gprojector/";
    maintainers = with lib.maintainers; [ alyaeanyx ];
    license = lib.licenses.unfree;
    inherit (jre.meta) platforms;
  };
}
