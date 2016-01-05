{ fetchurl, stdenv, bash, jre8 }:

stdenv.mkDerivation rec {
  name = "josm-${version}";
  version = "9060";

  src = fetchurl {
    url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
    sha256 = "0c1q0bs3x1j9wzmb52xnppdyvni4li5khbfja7axn2ml09hqa0j2";
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
