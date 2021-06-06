{ lib, stdenv, fetchFromGitHub, makeWrapper
, adoptopenjdk-bin, jre, ant
}:

stdenv.mkDerivation rec {
  pname = "tlaplus";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner  = "tlaplus";
    repo   = "tlaplus";
    rev    = "refs/tags/v${version}";
    sha256 = "1mm6r9bq79zks50yk0agcpdkw9yy994m38ibmgpb3bi3wkpq9891";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ adoptopenjdk-bin ant ];

  buildPhase = "ant -f tlatools/org.lamport.tlatools/customBuild.xml compile dist";
  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp tlatools/org.lamport.tlatools/dist/*.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/tlc2 \
      --add-flags "-cp $out/share/java/tla2tools.jar tlc2.TLC"
    makeWrapper ${jre}/bin/java $out/bin/tla2sany \
      --add-flags "-cp $out/share/java/tla2tools.jar tla2sany.SANY"
    makeWrapper ${jre}/bin/java $out/bin/pcal \
      --add-flags "-cp $out/share/java/tla2tools.jar pcal.trans"
    makeWrapper ${jre}/bin/java $out/bin/tla2tex \
      --add-flags "-cp $out/share/java/tla2tools.jar tla2tex.TLA"
  '';

  meta = {
    description = "An algorithm specification language with model checking tools";
    homepage    = "http://lamport.azurewebsites.net/tla/tla.html";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
