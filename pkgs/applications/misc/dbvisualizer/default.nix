{ stdenv, fetchurl, jre, coreutils, makeWrapper }:

stdenv.mkDerivation {
  name = "dbvisualizer-9.5.7";

  src = fetchurl {
    url = https://www.dbvis.com/product_download/dbvis-9.5.7/media/dbvis_unix_9_5_7.tar.gz;
    sha256 = "1xv4fw7cji2ffvv7z8vjl5lap512pj60s2ynihirrqld7pmklnyr";
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
