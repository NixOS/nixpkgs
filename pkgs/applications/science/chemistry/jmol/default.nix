{ stdenv, fetchurl, makeDesktopItem, jre }:

with stdenv.lib;

let
  ver_maj = "14.25";
  ver_min = "2";

  desktopItem = makeDesktopItem {
    name = "jmol";
    exec = "jmol";
    desktopName = "JMol";
    genericName = "Molecular Modeler";
    mimeType = "chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;";
    categories = "Graphics;Education;Science;Chemistry;";
  };
in
stdenv.mkDerivation {
  name = "jmol-${ver_maj}";
  src = fetchurl {
    url = "https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.25/Jmol%2014.25.2/Jmol-14.25.2-binary.tar.gz/download";
    sha256 = "36ba458ecb5b6068ea25c9482d673c78723ceb413a38571f2da3ac6af3cd1e3b";
    name = "jmol.tar.gz";
  };

  patchPhase = ''
    sed -i -e "4s:.*:command=${jre}/bin/java:" -e "10s:.*:jarpath=$out/share/Jmol.jar:" -e "11,21d" jmol
  '';

  installPhase = ''
    mkdir $out $out/bin $out/share
    cp jmol $out/bin
    cp -r *.jar ${desktopItem}/share/applications $out/share
  '';

  meta = {
    description = "A free, open source molecule viewer";
    homepage = http://jmol.sourceforge.net;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ mounium ];
  };
}
