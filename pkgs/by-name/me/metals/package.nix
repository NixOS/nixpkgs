{
  stdenv,
  lib,
  coursier,
  jre,
  makeWrapper,
  setJavaClassPath,
  callPackage,
  extraJavaOpts ? "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metals";
  version = "1.6.8";

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ finalAttrs.passthru.deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/metals \
      --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"

    makeWrapper ${jre}/bin/java $out/bin/metals-mcp \
      --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.McpMain"

    runHook postInstall
  '';

  passthru.updateScript = {
    command = lib.getExe (callPackage ./update.nix { });
    supportedFeatures = [ "commit" ];
  };

  passthru.deps = stdenv.mkDerivation {
    name = "metals-deps-${finalAttrs.version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:metals_2.13:${finalAttrs.version} org.scalameta:metals-mcp_2.13:${finalAttrs.version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-LdZ6I7zOUTHgS/TTo0T6Dh+Kb3YpgJg8gK0UngsA7Gs=";
  };

  meta = {
    homepage = "https://scalameta.org/metals/";
    changelog = "https://github.com/scalameta/metals/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    description = "Language server for Scala";
    mainProgram = "metals";
    # a jar plus a launcher wrapper, so it runs wherever the jre does
    platforms = jre.meta.platforms;
    maintainers = with lib.maintainers; [
      agilesteel
      fabianhjr
      jpaju
      tomahna
    ];
  };
})
