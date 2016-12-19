{ stdenv, fetchurl, jre }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.0.0";
  name = "frostwire-${version}";

  src = fetchurl {
    url = "http://dl.frostwire.com/frostwire/${version}/frostwire-${version}.x86_64.tar.gz";
    sha256 = "16rpfh235jj75vm4rx6qqw25ax3rk2p21l6lippbm0pi13lp2pdh";
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
    platforms = stdenv.lib.platforms.unix;
  };
}
