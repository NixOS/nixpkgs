{
  stdenvNoCC,
  lib,
  fetchurl,
  jre,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  writeScript,
  extraJavaArgs ? "-Xms512M -Xmx2000M",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gprojector";
  version = "3.4.7";

  src = fetchurl {
    url = "https://www.giss.nasa.gov/tools/gprojector/download/G.ProjectorJ-${finalAttrs.version}.tgz";
    hash = "sha256-DOpRS1oJTWmakkZhR50QDb2BI5MJKQMdVLOTVeQzv7Q=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "gprojector";
      exec = "gprojector";
      desktopName = "G.Projector";
      comment = finalAttrs.meta.description;
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
    cp -r ./jars $out/share/java
    makeWrapper ${jre}/bin/java $out/bin/gprojector --add-flags "-jar $out/share/java/G.Projector.jar" --add-flags "${extraJavaArgs}"
    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-${finalAttrs.pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts
    version="$(list-directory-versions --pname 'G.ProjectorJ' \
      --url https://www.giss.nasa.gov/tools/gprojector/download/ \
      | sort -V | tail -n1)"
    update-source-version ${finalAttrs.pname} "$version"
  '';

  meta = {
    description = "G.Projector transforms an input map image into any of about 200 global and regional map projections";
    homepage = "https://www.giss.nasa.gov/tools/gprojector/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "gprojector";
    maintainers = with lib.maintainers; [ pentane ];
    license = lib.licenses.unfree;
    inherit (jre.meta) platforms;
  };
})
