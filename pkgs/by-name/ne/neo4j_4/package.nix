{
  coreutils,
  fetchzip,
  findutils,
  gawk,
  lib,
  makeWrapper,
  openjdk11,
  stdenvNoCC,
  versionCheckHook,
  which,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "neo4j";
  version = "4.4.46";

  src = fetchzip {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${finalAttrs.version}-unix.tar.gz";
    hash = "sha256-qeA6lP8gqvwtJSMdJgJ0Iy2MMrtGhhUIOa4A6traSNg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/neo4j}
    cp -R * $out/share/neo4j

    for NEO4J_SCRIPT in neo4j neo4j-admin cypher-shell; do
      f="$out/share/neo4j/bin/$NEO4J_SCRIPT"
      patchShebangs "$f"
      makeWrapper "$f" "$out/bin/$NEO4J_SCRIPT" \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            findutils
            gawk
            openjdk11
            which
          ]
        } \
        --set JAVA_HOME ${openjdk11} \
        --run '
          if [ ! -v NEO4J_HOME ]; then
            echo "error: NEO4J_HOME must be set!" >&2
            exit 1
          fi'
    done

    runHook postInstall
  '';

  env.NEO4J_HOME = "/tmp/neo4j";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "NEO4J_HOME" ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Highly scalable, robust (fully ACID) native graph database";
    homepage = "https://neo4j.com";
    changelog = "https://neo4j.com/release-notes/database/neo4j-${finalAttrs.version}";
    downloadPage = "https://neo4j.com/deployment-center";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eleonora ];
    mainProgram = "neo4j";
  };
})
