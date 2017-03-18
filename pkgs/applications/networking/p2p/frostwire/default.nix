{ stdenv, fetchurl, jre }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.4.5";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "http://dl.frostwire.com/frostwire/${version}/frostwire-${version}.noarch.tar.gz";
    sha256 = "01nq1vwkqdidmprlnz5d3c5412r6igv689barv64dmb9m6iqg53z";
  };

  inherit jre;

  installPhase = ''
    jar=$(ls */*.jar)
    
    mkdir -p $out/share/java
    mv $jar $out/share/java
    
    mkdir -p $out/bin
    cat > $out/bin/frostwire <<EOF
    #! $SHELL -e
    exec $out/share/java/frostwire
    EOF
    chmod +x $out/bin/frostwire
  '';

  meta = with stdenv.lib; {
    homepage = http://www.frostwire.com/;
    description = "BitTorrent Client and Cloud File Downloader";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = platforms.all;
  };
}
