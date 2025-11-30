{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  wrapGAppsHook3,
  jre,
}:
let
  jre' = jre.override {
    enableJavaFX = true;
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mcaselector";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${finalAttrs.version}/mcaselector-${finalAttrs.version}.jar";
    hash = "sha256-yDTXD0CKjCi2DuJHmMuypeAY3sm3tJOmu2OWt4p+czM=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    jre'
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/mcaselector}
    cp $src $out/lib/mcaselector/mcaselector.jar

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${jre'}/bin/java $out/bin/mcaselector \
      --add-flags "-jar $out/lib/mcaselector/mcaselector.jar" \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    homepage = "https://github.com/Querz/mcaselector";
    description = "Tool to select chunks from Minecraft worlds for deletion or export";
    mainProgram = "mcaselector";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = [ maintainers.Scrumplex ];
    platforms = platforms.linux;
  };
})
