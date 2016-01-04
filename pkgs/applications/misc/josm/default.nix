{ fetchurl, stdenv, bash, jre8 }:

stdenv.mkDerivation rec {
  name = "josm-${version}";
  version = "9229";

  src = fetchurl {
    url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
    sha256 = "1a70y2a2srnlca7m5kcg8zijxnmiazhpr6fjl2vwzg00ghv0nxzb";
  };

  phases = [ "installPhase" ];

  buildInputs = [ jre8 ];

  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp -v $src $out/share/java/josm.jar
    cat > $out/bin/josm <<EOF
    #!${bash}/bin/bash
    exec ${jre8}/bin/java -jar $out/share/java/josm.jar "\$@"
    EOF
    chmod 755 $out/bin/josm
  '';

  meta = with stdenv.lib; {
    description = "An extensible editor for ​OpenStreetMap";
    homepage = https://josm.openstreetmap.de/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
  };
}
