{ lib, stdenv, fetchurl, jre, unzip, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "weka";
  version = "3.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/weka/${lib.replaceChars ["."]["-"] "${pname}-${version}"}.zip";
    sha256 = "0zwmhspmqb0a7cm6k6i0s6q3w19ws1g9dx3cp2v3g3vsif6cdh31";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  # The -Xmx1000M comes suggested from their download page:
  # http://www.cs.waikato.ac.nz/ml/weka/downloading.html
  installPhase = ''
    mkdir -pv $out/share/weka
    cp -Rv * $out/share/weka

    makeWrapper ${jre}/bin/java $out/bin/weka \
      --add-flags "-Xmx1000M -jar $out/share/weka/weka.jar"
  '';

  meta = {
    homepage = "http://www.cs.waikato.ac.nz/ml/weka/";
    description = "Collection of machine learning algorithms for data mining tasks";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.mimame ];
    platforms = lib.platforms.unix;
  };
}
