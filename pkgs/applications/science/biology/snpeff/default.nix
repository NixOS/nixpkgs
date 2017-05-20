{stdenv, fetchurl, jre, unzip, makeWrapper}:

stdenv.mkDerivation rec {
  name = "snpeff-${version}";
  version = "4.3i";

  src = fetchurl {
    url = "mirror://sourceforge/project/snpeff/snpEff_latest_core.zip";
    sha256 = "0i1slg201c8yjfr4wrg4xcgzwi0c8b9l3fb1i73fphq6q6zdblzb";
  };

  buildInputs = [ unzip jre makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/snpeff
    cp *.jar *.config $out/libexec/snpeff

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/snpeff --add-flags "-jar $out/libexec/snpeff/snpEff.jar"
    makeWrapper ${jre}/bin/java $out/bin/snpsift --add-flags "-jar $out/libexec/snpeff/SnpSift.jar"
  '';

  meta = with stdenv.lib; {
    description = "Genetic variant annotation and effect prediction toolbox.";
    license = licenses.lgpl3;
    homepage = http://snpeff.sourceforge.net/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };

}
