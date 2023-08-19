{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "tlaplus";
  version = "1.7.3";

  src = fetchurl {
    url = "https://github.com/tlaplus/tlaplus/releases/download/v${version}/tla2tools.jar";
    sha256 = "sha256-5P8V6oH05voSXAgwBDclSxdxdMalrfaNpElkar4IUZ0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/tla2tools.jar

    makeWrapper ${lib.getExe jre} $out/bin/tlc \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tlc2.TLC"
    makeWrapper ${lib.getExe jre} $out/bin/tlasany \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tla2sany.SANY"
    makeWrapper ${lib.getExe jre} $out/bin/pcal \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar pcal.trans"
    makeWrapper ${lib.getExe jre} $out/bin/tlatex \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tla2tex.TLA"
  '';

  meta = {
    description = "An algorithm specification language with model checking tools";
    homepage    = "http://lamport.azurewebsites.net/tla/tla.html";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ florentc thoughtpolice mgregson ];
  };
}
