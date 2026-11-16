{
  lib,
  fetchFromBitbucket,
  makeWrapper,
  maven,
}:
maven.buildMavenPackage (finalAttrs: {

  pname = "rpgframework";

  version = "5.6.1";

  __structuredAttrs = true;

  strictDeps = true;

  checkMeta = true;

  src = fetchFromBitbucket {
    owner = "rpgframework-cloud";
    repo = "rpgframework";
    rev = "${finalAttrs.version}";
    hash = "sha256-1saqFKaUVDcH4BPvZrmxcvb1GN/4OG+32U1m97n60Vc=";
  };

  mvnHash = "sha256-ClITqfTazkch+G7RuD1xpnc9216zIJdSegi2nS/pvPA=";

  nativeBuildInputs = [ makeWrapper ];

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
    description = "Build Framework";
    homepage = "https://www.rpgframework.de";
    downloadPage = "https://bitbucket.org/rpgframework-cloud/rpgframework/src/master/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = with lib.platforms; [
      linux
      windows
    ];
  };
})
