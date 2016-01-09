{ fetchurl, stdenv, bash, jre8 }:

stdenv.mkDerivation rec {
  name = "josm-${version}";
  version = "9329";

  src = fetchurl {
    url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
    sha256 = "084a3pizmz09abn2n7brhx6757bq9k3xq3jy8ip2ifbl2hcrw7pq";
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
