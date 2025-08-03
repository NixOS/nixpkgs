{
  lib,
  stdenvNoCC,
  fetchurl,
  gitUpdater,
  jre_headless,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jol-cli";
  version = "0.17";

  src = fetchurl {
    url = "mirror://maven/org/openjdk/jol/jol-cli/${finalAttrs.version}/jol-cli-${finalAttrs.version}-full.jar";
    hash = "sha256-6ozzG33GwYgQynrq3L56KzUvslAmG4BgzlE+ipnrzRI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp $src $out/share/${finalAttrs.pname}.jar
    makeWrapper "${jre_headless}/bin/java" $out/bin/jol-cli \
      --add-flags "-jar $out/share/${finalAttrs.pname}.jar"

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/openjdk/jol";
  };

  meta = {
    description = "Java Object Layout (JOL)";
    longDescription = ''
      JOL (Java Object Layout) is the tiny toolbox to analyze object layout in
      JVMs. These tools are using Unsafe, JVMTI, and Serviceability Agent (SA)
      heavily to decode the actual object layout, footprint, and references.
      This makes JOL much more accurate than other tools relying on heap dumps,
      specification assumptions, etc.
    '';
    homepage = "https://openjdk.org/projects/code-tools/jol/";
    license = lib.licenses.gpl2ClasspathPlus;
    mainProgram = "jol-cli";
    maintainers = with lib.maintainers; [ debling ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
