{ stdenv, fetchurl, unzip, jre }:

with stdenv;

mkDerivation rec {

  version = "8";
  name = "zdfmediathk";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/zdfmediathk/Mediathek/Mediathek%208/MediathekView_${version}.zip";
    sha256 = "1sglzk8zh6cyijyw82k49yqzjv0ywglp03w09s7wr4mzk48mfjj9";
  };

  buildInputs = [ unzip ];

  unpackPhase = "unzip $src";

  installPhase = ''
    mkdir -p $out/{lib,bin,share/{doc,licenses}}
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
    homepage = "http://zdfmediathk.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = [ maintainers.flosse ];
    platforms = platforms.all;
  };

}
