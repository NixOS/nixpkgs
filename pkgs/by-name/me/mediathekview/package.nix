{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  makeWrapper,
  libglvnd,
  libnotify,
  openjdk25, # 2025-12-25: pkgs.jre points to java 21 and there is no equivalent for jre25
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "14.4.2";
  pname = "mediathekview";
  src = fetchurl {
    url = "https://download.mediathekview.de/stabil/MediathekView-${finalAttrs.version}-linux.tar.gz";
    sha256 = "sha256-sDZSXYzak2RKQiW1OGpgSvFlkZrttsoOxVqRaodol24=";
  };

  nativeBuildInputs = [
    makeWrapper
    zip
  ];

  installPhase =
    let
      libraryPath = lib.strings.makeLibraryPath [
        libglvnd
        libnotify
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/{bin,lib}

      install -m644 MediathekView.jar $out/lib
      cp -r dependency $out/lib

      makeWrapper ${openjdk25}/bin/java $out/bin/mediathek \
        --add-flags "--add-exports=java.desktop/sun.swing=ALL-UNNAMED -XX:MaxRAMPercentage=10.0 -XX:+UseShenandoahGC -XX:ShenandoahGCHeuristics=compact -XX:+UseStringDeduplication --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --enable-native-access=ALL-UNNAMED -cp \"$out/lib/dependency/*:$out/lib/MediathekView.jar\" mediathek.Main" \
        --suffix LD_LIBRARY_PATH : "${libraryPath}"

      ln -s $out/bin/mediathek $out/bin/MediathekView

      makeWrapper ${openjdk25}/bin/java $out/bin/MediathekView_ipv4 \
      --add-flags "-Djava.net.preferIPv4Stack=true --add-exports=java.desktop/sun.swing=ALL-UNNAMED -XX:MaxRAMPercentage=10.0 -XX:+UseShenandoahGC -XX:ShenandoahGCHeuristics=compact -XX:+UseStringDeduplication --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --enable-native-access=ALL-UNNAMED -cp \"$out/lib/dependency/*:$out/lib/MediathekView.jar\" mediathek.Main" \
        --suffix LD_LIBRARY_PATH : "${libraryPath}"

      runHook postInstall
    '';

  doInstallCheck = true;
  # sanity to ensure that mediathek can actually start
  # unfortunately the executable does not print its own version
  installCheckPhase = ''
    runHook postCheck
    ($out/bin/${finalAttrs.meta.mainProgram} --help 2>&1 ||: ) | grep -q 'Diese Version von MediathekView unterst?tzt keine Kommandozeilenausf?hrung.'
    runHook preCheck
  '';

  meta = {
    description = "Offers access to the Mediathek of different tv stations (ARD, ZDF, Arte, etc.)";
    homepage = "https://mediathekview.de/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "mediathek";
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.all;
  };
})
