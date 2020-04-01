{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "13.5.1";
  pname = "mediathekview";
  src = fetchurl {
    url = "https://download.mediathekview.de/stabil/MediathekView-${version}-linux.tar.gz";
    sha256 = "0fixr6drim0wmh4q44zikcla4mrnm44nm95d5naqsgx6idalddrc";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,lib}

    install -m644 MediathekView.jar $out/lib

    makeWrapper ${jre}/bin/java $out/bin/mediathek \
      --add-flags "-Xmx1G -jar $out/lib/MediathekView.jar"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView \
      --add-flags "-Xmx1G -jar $out/lib/MediathekView.jar"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView_ipv4 \
      --add-flags "-Xmx1G -Djava.net.preferIPv4Stack=true -jar $out/lib/MediathekView.jar"
  '';

  meta = with stdenv.lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = https://mediathekview.de/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.all;
  };
}
