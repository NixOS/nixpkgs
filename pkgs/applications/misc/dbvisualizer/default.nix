{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "dbvisualizer";
  version = "10.0.25";

  src = fetchurl {
    url = "https://www.dbvis.com/product_download/dbvis-${version}/media/dbvis_unix_${stdenv.lib.strings.replaceChars ["."] ["_"] version}.tar.gz";
    sha256 = "0f9lqsvyxy0wa6hgdvc9vxvfb44xb46fgcdj5g9y013cj4nsqzf1";
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
