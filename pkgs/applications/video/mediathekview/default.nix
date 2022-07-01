{ lib, stdenv, fetchurl, makeWrapper, jre, zip }:

stdenv.mkDerivation rec {
  version = "13.8.0";
  pname = "mediathekview";
  src = fetchurl {
    url = "https://download.mediathekview.de/stabil/MediathekView-${version}-linux.tar.gz";
    sha256 = "0zfkwz5psv7m0881ykgqrxwjhadg39c55aj2wpy7m1jdara86c5q";
  };

  nativeBuildInputs = [ makeWrapper zip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    # log4j mitigation, see https://logging.apache.org/log4j/2.x/security.html
    zip -d MediathekView.jar org/apache/logging/log4j/core/lookup/JndiLookup.class

    install -m644 MediathekView.jar $out/lib

    makeWrapper ${jre}/bin/java $out/bin/mediathek \
      --add-flags "-jar $out/lib/MediathekView.jar"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView \
      --add-flags "-jar $out/lib/MediathekView.jar"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView_ipv4 \
      --add-flags "-Djava.net.preferIPv4Stack=true -jar $out/lib/MediathekView.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = "https://mediathekview.de/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.all;
  };
}
