{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "13.7.1";
  pname = "mediathekview";
  src = fetchurl {
    url = "https://download.mediathekview.de/stabil/MediathekView-${version}-linux.tar.gz";
    sha256 = "sha256-yFPyj1Mbgj2eJv4DpvfOtPyTbL9gMAXC5TzSx8AV27o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,lib}

    install -m644 MediathekView.jar $out/lib

    makeWrapper ${jre}/bin/java $out/bin/mediathek \
      --add-flags "-Xmx1G --enable-preview -jar $out/lib/MediathekView.jar"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView \
      --add-flags "-Xmx1G --enable-preview -jar $out/lib/MediathekView.jar"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView_ipv4 \
      --add-flags "-Xmx1G --enable-preview -Djava.net.preferIPv4Stack=true -jar $out/lib/MediathekView.jar"
  '';

  meta = with lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = "https://mediathekview.de/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.all;
  };
}
