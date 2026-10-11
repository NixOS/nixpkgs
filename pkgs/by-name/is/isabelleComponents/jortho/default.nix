{
  fetchMavenArtifact,
  scowl,
  gzip,
  runCommand,
  addSettings,
}:

let
  jortho_jar = fetchMavenArtifact {
    groupId = "io.github.geniot";
    artifactId = "jortho";
    inherit (jortho_with_dict) version;
    hash = "sha256-1FO2aGX3dt7Z72mXtUWqkfcHDnzAxPXwBqwUCNn2IUk=";
  };

  jortho_with_dict =
    runCommand "jortho-1.0"
      {
        pname = "jortho";
        version = "1.0";

        nativeBuildInputs = [
          jortho_jar
          scowl
          gzip
        ];
      }
      ''
        mkdir -p $out/share/dict $out/share/java
        cp ${scowl}/share/dict/waustralian.txt $out/share/dict/en_AU
        cp ${scowl}/share/dict/wcanadian.txt $out/share/dict/en_CA
        cp ${scowl}/share/dict/wbritish_s.txt $out/share/dict/en_GB-ise
        cp ${scowl}/share/dict/wbritish_z.txt $out/share/dict/en_GB-ize
        cp ${scowl}/share/dict/wamerican.txt $out/share/dict/en_US
        cat $out/share/dict/{en_AU,en_CA,en_GB-ise,en_GB-ize,en_US} | sort -u > $out/share/dict/en
        gzip $out/share/dict/{en_AU,en_CA,en_GB-ise,en_GB-ize,en_US,en}
        install -m644 ${jortho_jar}/share/java/*.jar $out/share/java
      '';
in
addSettings jortho_with_dict (finalAttrs: ''
  JORTHO_HOME="${finalAttrs.finalPackage}"
  JORTHO_DICTIONARIES="$JORTHO_HOME/share/dict/en_AU.gz:$JORTHO_HOME/share/dict/en_CA.gz:$JORTHO_HOME/share/dict/en_GB-ise.gz:$JORTHO_HOME/share/dict/en_GB-ize.gz:$JORTHO_HOME/share/dict/en_US.gz"

  classpath "$JORTHO_HOME/share/java/jortho-${finalAttrs.version}.jar"
'')
