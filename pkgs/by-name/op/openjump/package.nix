{ lib, stdenv, fetchurl, unzip, makeWrapper
, coreutils, gawk, which, gnugrep, findutils
, jre
}:

stdenv.mkDerivation rec {
  pname = "openjump";
  version = "2.2.1";
  revision = "r5222%5B94156e5%5D";

  src = fetchurl {
    url = "mirror://sourceforge/jump-pilot/OpenJUMP/${version}/OpenJUMP-Portable-${version}-${revision}-PLUS.zip";
    hash = "sha256-+/AMmD6NDPy+2Gq1Ji5i/QWGU7FOsU+kKsWoNXcx/VI=";
  };

  # TODO: build from source
  unpackPhase = ''
    mkdir -p $out/opt
    unzip $src -d $out/opt
  '';

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    dir=$(echo $out/opt/OpenJUMP-*)

    chmod +x "$dir/bin/oj_linux.sh"
    makeWrapper "$dir/bin/oj_linux.sh" $out/bin/OpenJump \
      --set JAVA_HOME ${jre} \
      --set PATH ${lib.makeBinPath [ coreutils gawk which gnugrep findutils ]}
  '';

  meta = {
    description = "Open source Geographic Information System (GIS) written in the Java programming language";
    homepage = "http://www.openjump.org/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.gpl2;
    maintainers = lib.teams.geospatial.members ++ [ lib.maintainers.marcweber ];
    platforms = jre.meta.platforms;
    mainProgram = "OpenJump";
  };
}
