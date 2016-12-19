{ stdenv, fetchurl, jre, coreutils, makeWrapper }:

stdenv.mkDerivation {
  name = "dbvisualizer-9.5";

  src = fetchurl {
    url = https://www.dbvis.com/product_download/dbvis-9.5/media/dbvis_unix_9_5.tar.gz;
    sha256 = "1bdc03039b50807206fd72ecf8ba0b940f5bb0386f483e10b7c0b2fa75cac021";
  };

  buildInputs = [ makeWrapper ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp -a . $out
    ln -sf $out/dbvis $out/bin    
    wrapProgram $out/bin/dbvis --set INSTALL4J_JAVA_HOME ${jre}
  '';
  
  meta = {
    description = "The universal database tool";
    homepage = https://www.dbvis.com/;
    license = stdenv.lib.licenses.unfree;
  };
}
