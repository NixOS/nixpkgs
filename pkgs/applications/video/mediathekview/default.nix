{ lib, stdenv, fetchurl, makeWrapper, libglvnd, libnotify, jre, copyDesktopItems, makeDesktopItem, zip }:

stdenv.mkDerivation rec {
  version = "14.0.0";
  pname = "mediathekview";
  src = fetchurl {
    url = "https://download.mediathekview.de/stabil/MediathekView-${version}-linux.tar.gz";
    sha256 = "sha256-vr0yqKVRodtXalHEIsm5gdEp9wPU9U5nnYhMk7IiPF4=";
  };


  nativeBuildInputs = [ copyDesktopItems makeWrapper zip ];

  installPhase =
  let
    libraryPath = lib.strings.makeLibraryPath [ libglvnd libnotify ];
  in
  ''
    runHook preInstall

    mkdir -p $out/{bin,lib} $out/share/pixmaps

    install -m644 MediathekView.jar $out/lib
    install -m644 MediathekView.svg $out/share/pixmaps

    makeWrapper ${jre}/bin/java $out/bin/mediathek \
      --add-flags "-jar $out/lib/MediathekView.jar" \
      --suffix LD_LIBRARY_PATH : "${libraryPath}"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView \
      --add-flags "-jar $out/lib/MediathekView.jar" \
      --suffix LD_LIBRARY_PATH : "${libraryPath}"

    makeWrapper ${jre}/bin/java $out/bin/MediathekView_ipv4 \
      --add-flags "-Djava.net.preferIPv4Stack=true -jar $out/lib/MediathekView.jar" \
      --suffix LD_LIBRARY_PATH : "${libraryPath}"

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = "MediathekView";
    exec = "mediathek";
    icon = "MediathekView";
    desktopName = "MediathekView";
    comment = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    type = "Application";
    categories = [ "Video" "AudioVideo" ];
    startupNotify = true;
  };

  meta = with lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = "https://mediathekview.de/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    mainProgram = "mediathek";
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.all;
  };
}
