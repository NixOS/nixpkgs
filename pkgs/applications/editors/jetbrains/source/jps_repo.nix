{
  # keep-sorted start
  ant,
  jbr,
  jpsHash,
  runCommand,
  src,
  # keep-sorted end
}:
runCommand "jps-bootstrap-repository"
  {
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = jpsHash;
    nativeBuildInputs = [
      # keep-sorted start
      ant
      jbr
      # keep-sorted end
    ];
  }
  ''
    ant -Duser.home=$out -Dbuild.dir=$(mktemp -d) -f ${src}/platform/jps-bootstrap/jps-bootstrap-classpath.xml
    find $out -type f \( \
      -name \*.lastUpdated \
      -o -name resolver-status.properties \
      -o -name _remote.repositories \) \
      -delete
  ''
