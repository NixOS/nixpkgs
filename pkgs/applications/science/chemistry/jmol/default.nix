{ stdenv
, lib
, fetchurl
, unzip
, makeDesktopItem
, jre
}:

let
  desktopItem = makeDesktopItem {
    name = "jmol";
    exec = "jmol";
    desktopName = "JMol";
    genericName = "Molecular Modeler";
    mimeType = "chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;";
    categories = "Graphics;Education;Science;Chemistry;";
  };
in
stdenv.mkDerivation rec {
  version = "14.29.46";
  pname = "jmol";

  src = let
    baseVersion = "${lib.versions.major version}.${lib.versions.minor version}";
  in fetchurl {
    url = "mirror://sourceforge/jmol/Jmol/Version%20${baseVersion}/Jmol%20${version}/Jmol-${version}-binary.tar.gz";
    sha256 = "00ig1f1fz5qbkam0h06vs1gsb95hdqa0iyhsp4qbyjjfxir7m59l";
  };

  patchPhase = ''
    sed -i -e "4s:.*:command=${jre}/bin/java:" -e "10s:.*:jarpath=$out/share/jmol/Jmol.jar:" -e "11,21d" jmol
  '';

  installPhase = ''
    mkdir -p "$out/share/jmol" "$out/bin"

    ${unzip}/bin/unzip jsmol.zip -d "$out/share/"

    cp *.jar jmol.sh "$out/share/jmol"
    cp -r ${desktopItem}/share/applications $out/share
    cp jmol $out/bin
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
     description = "A Java 3D viewer for chemical structures";
     homepage = https://sourceforge.net/projects/jmol;
     license = licenses.lgpl2;
     platforms = platforms.all;
     maintainers = with maintainers; [ timokau mounium ];
  };
}
