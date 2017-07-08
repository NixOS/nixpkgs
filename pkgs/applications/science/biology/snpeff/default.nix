{stdenv, fetchurl, jre, unzip, makeWrapper}:

stdenv.mkDerivation rec {
  name = "snpeff-${version}";
  version = "4.3p";

  src = fetchurl {
    url = "mirror://sourceforge/project/snpeff/snpEff_v4_3p_core.zip";
    sha256 = "1xb3k0yxd634znw2q083ligm2ww4p6v64041r9sdy3930lhjvxb1";
  };

  buildInputs = [ unzip jre makeWrapper ];

  sourceRoot = "snpEff";

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
