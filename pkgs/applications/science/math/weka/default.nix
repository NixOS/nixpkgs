{ stdenv, fetchurl, jre, unzip }:

stdenv.mkDerivation rec {
  name = "weka-${version}";
  version = "3.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/weka/${stdenv.lib.replaceChars ["."]["-"] name}.zip";
    sha256 = "0p353lhhcv3swwn1bl64vkyjk480vv9ghhlyqjxiar4p3xifjayb";
  };

  buildInputs = [ unzip ];

  # The -Xmx1000M comes suggested from their download page:
  # http://www.cs.waikato.ac.nz/ml/weka/downloading.html
  installPhase = ''
    mkdir -pv $out/share/weka $out/bin
    cp -Rv * $out/share/weka

    cat > $out/bin/weka << EOF
    #!${stdenv.shell}
    ${jre}/bin/java -Xmx1000M -jar $out/share/weka/weka.jar
    EOF

    chmod +x $out/bin/weka
  '';

  meta = {
    homepage = http://www.cs.waikato.ac.nz/ml/weka/;
    description = "Collection of machine learning algorithms for data mining tasks";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.mimadrid ];
    platforms = stdenv.lib.platforms.unix;
  };
}
