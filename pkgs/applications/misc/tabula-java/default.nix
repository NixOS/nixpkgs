{ stdenv, lib, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "tabula-java";
  version = "1.0.4";

  src = fetchurl {
    url = "https://github.com/tabulapdf/tabula-java/releases/download/v${version}/tabula-${version}-jar-with-dependencies.jar";
    sha256 = "12d0jcc3j0q8jbqv0gzfiif7c8ig37834vb8yq0jnyr0s72k30xw";
  };

  buildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -pv $out/share/tabula-java
    cp -v $src $out/share/tabula-java/tabula-java.jar

    makeWrapper ${jre}/bin/java $out/bin/tabula-java --add-flags "-jar $out/share/tabula-java/tabula-java.jar"
  '';

  meta = with lib; {
    description = "A library for extracting tables from PDF files.";
    longDescription = ''
      tabula-java is the table extraction engine that powers
      Tabula. You can use tabula-java as a command-line tool to
      programmatically extract tables from PDFs.
    '';
    homepage = "https://tabula.technology/";
    license = licenses.mit;
    maintainers = [ maintainers.jakewaksbaum ];
    platforms = platforms.all;
  };
}
