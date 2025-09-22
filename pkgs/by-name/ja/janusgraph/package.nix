{
  lib,
  stdenv,
  fetchzip,
  jdk11,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "janusgraph";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/JanusGraph/janusgraph/releases/download/v${version}/janusgraph-${version}.zip";
    sha256 = "sha256-gEtiY/FXNCtpVlohcTTuZ1V/EHr/trqYQKYUKy9wN4U=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/janusgraph
    install -D $src/lib/*.jar $out/share/janusgraph
    cd $src
    find conf scripts -type f -exec install -D {} $out/share/janusgraph/{} \;

    JANUSGRAPH_LIB=$out/share/janusgraph
    classpath=""
    # Add the slf4j-log4j12 binding
    classpath="$classpath":$(find -L $JANUSGRAPH_LIB -name 'slf4j-log4j12*.jar' | sort | tr '\n' ':')
    # Add the jars in $JANUSGRAPH_LIB that start with "janusgraph"
    classpath="$classpath":$(find -L $JANUSGRAPH_LIB -name 'janusgraph*.jar' | sort | tr '\n' ':')
    # Add the remaining jars in $JANUSGRAPH_LIB.
    classpath="$classpath":$(find -L $JANUSGRAPH_LIB -name '*.jar' \
                    \! -name 'janusgraph*' \
                    \! -name 'slf4j-log4j12*.jar' | sort | tr '\n' ':')

    makeWrapper ${jdk11}/bin/java $out/bin/janusgraph-server \
      --add-flags "-classpath $classpath org.janusgraph.graphdb.server.JanusGraphServer"

    # temporary workaround for
    # https://github.com/NixOS/nixpkgs/pull/244400#issuecomment-1667330430
    cd "$TMPDIR"
  '';

  meta = with lib; {
    description = "Open-source, distributed graph database";
    homepage = "https://janusgraph.org/";
    mainProgram = "janusgraph-server";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ners ];
  };
}
