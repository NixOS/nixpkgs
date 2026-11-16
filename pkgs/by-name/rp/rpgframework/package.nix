{
  lib,
  fetchFromBitbucket,
  maven,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "rpgframework";
  version = "5.6.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromBitbucket {
    owner = "rpgframework-cloud";
    repo = "rpgframework";
    tag = toString finalAttrs.version;
    hash = "sha256-1saqFKaUVDcH4BPvZrmxcvb1GN/4OG+32U1m97n60Vc=";
  };

  mvnHash = "sha256-KBxXh6Ap+MxS+rD+YVsViz2P40zJFFOwn4nGDrfCrcM=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    find . -type f -path '*/target/*.jar' \
      ! -name '*-sources.jar' \
      ! -name '*-javadoc.jar' \
      ! -name 'original-*.jar' \
      -exec install -Dm644 -t $out/share/java {} +

    runHook postInstall
  '';

  meta = {
    description = "RPGFramework - A roleplaying toolset";
    homepage = "https://www.rpgframework.de";
    downloadPage = "https://bitbucket.org/rpgframework-cloud/rpgframework/src/master/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = with lib.platforms; linux ++ windows ++ darwin;
  };
})
