{
  lib,
  stdenv,
  fetchurl,
  jre,
  unzip,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "snpeff";
  version = "4.3t";

  src = fetchurl {
    url = "mirror://sourceforge/project/snpeff/snpEff_v${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }_core.zip";
    sha256 = "0i12mv93bfv8xjwc3rs2x73d6hkvi7kgbbbx3ry984l3ly4p6nnm";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  buildInputs = [ jre ];

  sourceRoot = "snpEff";

  installPhase = ''
    mkdir -p $out/libexec/snpeff
    cp *.jar *.config $out/libexec/snpeff

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/snpeff --add-flags "-jar $out/libexec/snpeff/snpEff.jar"
    makeWrapper ${jre}/bin/java $out/bin/snpsift --add-flags "-jar $out/libexec/snpeff/SnpSift.jar"
  '';

  meta = with lib; {
    description = "Genetic variant annotation and effect prediction toolbox";
    license = licenses.lgpl3;
    homepage = "https://snpeff.sourceforge.net/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };

}
