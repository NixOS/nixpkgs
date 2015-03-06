{ stdenv, fetchurl, unzip, jre }:

with stdenv;

mkDerivation rec {

  version = "9";
  name = "zdfmediathk";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/zdfmediathk/Mediathek/Mediathek%209/MediathekView_${version}.zip";
    sha256 = "1wff0igr33z9p1mjw7yvb6658smdwnp22dv8klz0y8qg116wx7a4";
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
