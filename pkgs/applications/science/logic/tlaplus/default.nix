{ lib, stdenv, fetchurl, makeWrapper, adoptopenjdk-bin, jre }:

stdenv.mkDerivation rec {
  pname = "tlaplus";
  version = "1.7.2";

  src = fetchurl {
    url = "https://github.com/tlaplus/tlaplus/releases/download/v${version}/tla2tools.jar";
    sha256 = "sha256-+hhUPkTtWXSoW9LGDA3BZiCuEXaA6o5pPSaRmZ7ZCyI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ adoptopenjdk-bin ];

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/tla2tools.jar

    makeWrapper ${jre}/bin/java $out/bin/tlc \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tlc2.TLC"
    makeWrapper ${jre}/bin/java $out/bin/tlasany \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tla2sany.SANY"
    makeWrapper ${jre}/bin/java $out/bin/pcal \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar pcal.trans"
    makeWrapper ${jre}/bin/java $out/bin/tlatex \
      --add-flags "-XX:+UseParallelGC -cp $out/share/java/tla2tools.jar tla2tex.TLA"
  '';

  meta = {
    description = "An algorithm specification language with model checking tools";
    homepage    = "http://lamport.azurewebsites.net/tla/tla.html";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ florentc thoughtpolice ];
  };
}
