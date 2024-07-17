{
  lib,
  stdenv,
  fetchzip,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "tabula";
  version = "1.2.1";

  src = fetchzip {
    url = "https://github.com/tabulapdf/tabula/releases/download/v${version}/tabula-jar-${version}.zip";
    sha256 = "0lkpv8hkji81fanyxm7ph8421fr9a6phqc3pbhw2bc4gljg7sgxi";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share/tabula
    cp -v * $out/share/tabula

    makeWrapper ${jre}/bin/java $out/bin/tabula --add-flags "-jar $out/share/tabula/tabula.jar"
  '';

  meta = with lib; {
    description = "A tool for liberating data tables locked inside PDF files";
    longDescription = ''
      If you’ve ever tried to do anything with data provided to you in PDFs, you
      know how painful it is — there's no easy way to copy-and-paste rows of data
      out of PDF files. Tabula allows you to extract that data into a CSV or
      Microsoft Excel spreadsheet using a simple, easy-to-use interface.
    '';
    homepage = "https://tabula.technology/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = [ maintainers.dpaetzel ];
    platforms = platforms.all;
    broken = true; # on 2022-11-23 this package builds, but produces an executable that fails immediately
  };
}
