{ stdenv, fetchurl, jre, unzip }:

stdenv.mkDerivation {
  name = "weka-3.6.9";
  
  src = fetchurl {
    url = "mirror://sourceforge/weka/weka-3-6-9.zip";
    sha256 = "0rnis4vvihhdcdvpp79hkmklcnn897paa0qrs95cbjnpgvxzbczs";
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
    homepage = "http://www.cs.waikato.ac.nz/ml/weka/";
    description = "Collection of machine learning algorithms for data mining tasks";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
