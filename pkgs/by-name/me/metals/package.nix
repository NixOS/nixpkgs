{
  stdenv,
  lib,
  coursier,
  jre,
  makeWrapper,
  setJavaClassPath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metals";
  version = "1.6.7";

  deps = stdenv.mkDerivation {
    name = "metals-deps-${finalAttrs.version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:metals_2.13:${finalAttrs.version} org.scalameta:metals-mcp_2.13:${finalAttrs.version} \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-2ly1vO+06EalQjEekRwm/g2wfdbq26IcEQscfM14Gvc=";
  };

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ finalAttrs.deps ];

  dontUnpack = true;

  extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/metals \
      --add-flags "${finalAttrs.extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-mcp \
      --add-flags "${finalAttrs.extraJavaOpts} -cp $CLASSPATH scala.meta.metals.McpMain"
  '';

  meta = {
    homepage = "https://scalameta.org/metals/";
    license = lib.licenses.asl20;
    description = "Language server for Scala";
    mainProgram = "metals";
    maintainers = with lib.maintainers; [
      fabianhjr
      jpaju
      tomahna
    ];
  };
})
