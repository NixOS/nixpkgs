{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "13.2.1";
  name = "mediathekview-${version}";
  src = fetchurl {
    url = "https://download.mediathekview.de/stabil/MediathekView-${version}.tar.gz";
    sha256 = "11wg6klviig0h7pprfaygamsgqr7drqra2s4yxgfak6665033l2a";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{lib,bin,share/mediathekview}

    install -m644 MediathekView.jar $out/
    install -m644 -t $out/lib lib/*
    install -m755 bin/flv.sh $out/share/mediathekview

    makeWrapper ${jre}/bin/java $out/bin/mediathek \
      --add-flags "-cp '$out/lib/*' -jar $out/MediathekView.jar"
    '';

  meta = with stdenv.lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = https://mediathekview.de/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.all;
  };
}
