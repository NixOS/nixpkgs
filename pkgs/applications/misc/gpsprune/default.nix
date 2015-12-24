{ fetchurl, stdenv, bash, jre8 }:

stdenv.mkDerivation rec {
  name = "gpsprune-${version}";
  version = "18.2";

  src = fetchurl {
    url = "http://activityworkshop.net/software/gpsprune/gpsprune_${version}.jar";
    sha256 = "12zwwiy0jfrwvgrb110flx4b7k3sp3ivx8ijjymdbbk48xil93l2";
  };

  phases = [ "installPhase" ];

  buildInputs = [ jre8 ];

  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp -v $src $out/share/java/gpsprune.jar
    cat > $out/bin/gpsprune <<EOF
    #!${bash}/bin/bash
    exec ${jre8}/bin/java -jar $out/share/java/gpsprune.jar "\$@"
    EOF
    chmod 755 $out/bin/gpsprune
  '';

  meta = with stdenv.lib; {
    description = "Application for viewing, editing and converting GPS coordinate data";
    homepage = http://activityworkshop.net/software/gpsprune/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
  };
}
