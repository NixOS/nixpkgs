{ stdenv, fetchurl, unzip, jre }:

with stdenv;

mkDerivation rec {

  version = "10";
  name = "zdfmediathk-${version}";
  src = fetchurl {
    url = "https://github.com/xaverW/MediathekView/archive/Version${version}.tar.gz";
    sha256 = "12iyigqjslbn8rzym1mq1s0mvss7r97aiy6wfdrq5m0psarlcljw";
  };

  installPhase = ''
    mkdir -p $out/{lib,bin,share/{doc,licenses}}
    cd dist/
    install -m644 MediathekView.jar $out/
    install -m644 -t $out/lib lib/*
    install -m755 bin/flv.sh $out/bin/
    install -m644 -t $out/share/doc Anleitung/*.pdf
    install -m644 -t $out/share/licenses Copyright/{*.*,_copyright}
    bin="$out/bin/mediathek"
    cat >> "$bin" << EOF
    #!/bin/sh
    exec ${jre}/bin/java -cp "$out/lib/*" -Xms128M -Xmx1G -jar "$out/MediathekView.jar" "\$@"
    EOF
    chmod +x "$bin"
    '';

  meta = with stdenv.lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = https://github.com/xaverW/MediathekView/;
    license = licenses.gpl3;
    maintainers = [ maintainers.flosse ];
    platforms = platforms.all;
  };

}
