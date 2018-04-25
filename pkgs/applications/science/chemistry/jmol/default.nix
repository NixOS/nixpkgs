{ stdenv
, fetchurl
, unzip
, jre
}:

stdenv.mkDerivation rec {
  version = "${baseVersion}.${patchVersion}";
  baseVersion = "14.29";
  patchVersion = "12";
  pname = "jmol";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/jmol/Jmol/Version%20${baseVersion}/Jmol%20${version}/Jmol-${version}-binary.tar.gz";
    sha256 = "1ndq9am75janshrnk26334z1nmyh3k4bp20napvf2zv0lfp8k3bv";
  };

  buildInputs = [
    jre
  ];

  installPhase = ''
    mkdir -p "$out/share/jmol"
    mkdir -p "$out/bin"

    ${unzip}/bin/unzip jsmol.zip -d "$out/share/"

    sed -i -e 's|command=java|command=${jre}/bin/java|' jmol.sh
    cp *.jar jmol.sh "$out/share/jmol"
    ln -s $out/share/jmol/jmol.sh "$out/bin/jmol"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
     description = "A Java 3D viewer for chemical structures";
     homepage = https://sourceforge.net/projects/jmol;
     license = licenses.lgpl2;
     platforms = platforms.all;
     maintainers = with maintainers; [ timokau ];
  };
}

