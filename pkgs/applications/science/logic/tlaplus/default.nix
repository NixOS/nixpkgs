{ stdenv, fetchFromGitHub, makeWrapper
, jdk, jre, ant
}:

stdenv.mkDerivation rec {
  name = "tlaplus-${version}";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner  = "tlaplus";
    repo   = "tlaplus";
    rev    = "refs/tags/v${version}";
    sha256 = "0966mvgxamknj4hsp980qbxwda886w1dv309kn7isxn0420lfv4f";
  };

  buildInputs = [ makeWrapper jdk ant ];

  buildPhase = "ant -f tlatools/customBuild.xml compile dist";
  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp tlatools/dist/*.jar $out/share/java

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
    homepage    = http://lamport.azurewebsites.net/tla/tla.html;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
