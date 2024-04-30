{ lib, stdenv, fetchFromGitHub
, makeShellWrapper, makeDesktopItem, copyDesktopItems, wrapGAppsHook
, maven, jdk
, libglvnd, libnotify, libXxf86vm
}:
let
  mavenJdk = maven.override {
    inherit jdk;
  };
in
mavenJdk.buildMavenPackage rec {
  pname = "mediathekview";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "mediathekview";
    repo = "MediathekView";
    rev = "refs/tags/${version}";
    hash = "sha256-wVISldd5kixrCVatqI+ZUamh23Kul1QaTk+TDk55NMI=";
  };

  mvnParameters = toString [
    "-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"
    "-Dmaven.test.skip=true"
    {
      x86_64-linux = "-Plinux_64bit";
      aarch64-linux = "-Plinux_arm_64bit,!linux_64bit";
    }.${stdenv.hostPlatform.system}
  ];

  patches = [
    # makes the mvnHash platform-independent
    ./pom-remove-javafx.patch
  ];

  mvnHash = "sha256-bXTrVGdjWWCi3pck9o8z6+Q7S2o3fH7R2jXu+gJ6Vzk=";

  nativeBuildInputs = [
    wrapGAppsHook
    copyDesktopItems
    makeShellWrapper
  ];

  preBuild = ''
    VERSION=${version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    mkdir -p $out/share/icons/hicolor/512x512/apps

    install -m644 /build/source/target/MediathekView.jar $out/lib
    cp ${src}/res/MediathekView.svg $out/share/icons/hicolor/512x512/apps/de.mediathekview.MediathekView.svg

    makeShellWrapper ${jdk}/bin/java $out/bin/MediathekView \
      --add-flags "--enable-preview" \
      --add-flags "-Dfile.encoding=UTF-8" \
      --add-flags "-XX:+UseShenandoahGC" \
      --add-flags "-XX:ShenandoahGCHeuristics=compact" \
      --add-flags "-XX:+UseStringDeduplication" \
      --add-flags "-XX:MaxRAMPercentage=50.0" \
      --add-flags "--add-opens=javafx.base/com.sun.javafx.event=ALL-UNNAMED" \
      --add-flags "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED" \
      --add-flags "-DexternalUpdateCheck" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libnotify libXxf86vm libglvnd ]}" \
      --add-flags "-jar $out/lib/MediathekView.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "de.mediathekview.MediathekView.desktop";
      desktopName = "MediathekView";
      exec = "MediathekView";
      icon = "de.mediathekview.MediathekView";
      comment = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
      categories = [ "AudioVideo" "Player" ];
    })
  ];

  meta = with lib; {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = "https://mediathekview.de/";
    license = licenses.gpl3Plus;
    mainProgram = "mediathek";
    maintainers = with maintainers; [ moredread ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
}
