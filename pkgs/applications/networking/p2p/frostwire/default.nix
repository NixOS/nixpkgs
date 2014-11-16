{ stdenv, fetchurl, jre }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.0.0";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "http://dl.frostwire.com/frostwire/${version}/frostwire-${version}.x86_64.tar.gz";
    sha256 = "73d6e3db9971becf1c5b7faf12b62fa3ac0a243ac06b8b4eada9118f56990177";
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

  meta = {
    homepage = http://www.frostwire.com/;
    description = "BitTorrent Client and Cloud File Downloader";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.gavin ];
  };
}
