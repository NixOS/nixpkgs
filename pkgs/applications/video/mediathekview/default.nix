{ lib, stdenv, fetchurl, makeWrapper, libglvnd, libnotify, jre, copyDesktopItems, makeDesktopItem, zip, xorg }:

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
    libraryPath = lib.makeLibraryPath ([ libglvnd libnotify ]
      ++ lib.optional stdenv.isLinux xorg.libXxf86vm);
    # add JVM args from
    # https://github.com/mediathekview/MediathekView/blob/9105485f50ec10d863727b4817c8c4ffcbb02643/pom.xml#L136-L139
    jvmArgList = [
      "-XX:+UseShenandoahGC"
      "-XX:ShenandoahGCHeuristics=compact"
      "-XX:MaxRAMPercentage=50.0"
      "-XX:+UseStringDeduplication"
      "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED"
      "-Dfile.encoding=UTF-8"
      "-DexternalUpdateCheck" # disable checking for updates
    ];
    jvmArgs = lib.strings.concatStringsSep " " jvmArgList;
  in
  ''
    runHook preInstall

    mkdir -p $out/{bin,lib} $out/share/pixmaps

    install -m644 MediathekView.jar $out/lib
    install -m644 MediathekView.svg $out/share/pixmaps

    makeWrapper ${jre}/bin/java $out/bin/MediathekView \
      --add-flags "${jvmArgs} -jar $out/lib/MediathekView.jar" \
      --suffix LD_LIBRARY_PATH : "${libraryPath}"

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = "MediathekView";
    exec = "MediathekView";
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
    mainProgram = "MediathekView";
    maintainers = with maintainers; [ moredread ];
    platforms = platforms.all;
  };
}
