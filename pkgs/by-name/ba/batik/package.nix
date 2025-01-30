{
  lib,
  stdenvNoCC,
  fetchurl,
  jre,
  rhino,
  stripJavaArchivesHook,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "batik";
  version = "1.18";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/batik/binaries/batik-bin-${finalAttrs.version}.tar.gz";
    hash = "sha256-k2kC/441o0qizY9nwbWJh3Hv45FJeuDgrhynPhvZg0Y=";
  };

  nativeBuildInputs = [
    stripJavaArchivesHook
    makeWrapper
  ];

  buildInputs = [
    jre
    rhino
  ];

  patchPhase = ''
    # Vendored dependencies
    rm lib/rhino-*.jar
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp *.jar lib/*.jar $out/share/java
    chmod +x $out/share/java/*.jar
    classpath="$(find $out/share/java -name '*.jar' -printf '${rhino}/share/java/js.jar:%h/%f')"
    for appName in rasterizer slideshow squiggle svgpp ttf2svg; do
      makeWrapper ${lib.getExe jre} $out/bin/batik-$appName \
        --add-flags "-jar $out/share/java/batik-all-${finalAttrs.version}.jar" \
        --add-flags "-classpath $classpath" \
        --add-flags "org.apache.batik.apps.$appName.Main"
    done
  '';

  meta = with lib; {
    description = "Java based toolkit for handling SVG";
    homepage = "https://xmlgraphics.apache.org/batik";
    license = licenses.asl20;
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
