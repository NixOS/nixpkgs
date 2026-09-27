{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  gradle_9,
  jre25_minimal,
  libGL,
  libx11,
  pkg-config,
  fontconfig,
  wrapGAppsHook3,
  gtk3,
  autoPatchelfHook,
  nix-update-script,
  makeBinaryWrapper,
  imagemagick,
  makeDesktopItem,
  copyDesktopItems,
  # for linux-gpu-player (#142):
  mpv,
  libgbm,
  # for p2p support
  torrserver,
  # external player
  xdg-utils,
}:
let
  gradle = gradle_9;
  jre = jre25_minimal.override {
    modules = [
      "java.base"
      "java.datatransfer"
      "java.desktop"
      "java.instrument"
      "java.logging"
      "java.management"
      "java.net.http"
      "java.prefs"
      "java.xml"
      "jdk.crypto.ec"
      "jdk.httpserver"
      "jdk.unsupported"
    ];
  };

  # logging implementation
  slf4j-simple = fetchurl {
    url = "https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/2.1.0-alpha1/slf4j-simple-2.1.0-alpha1.jar";
    hash = "sha256-AU/trHoyKI7W+PcqEAfn+zKuxb/tsnFGfkluCVNIL3U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nuvio-desktop";
  version = "0.1.13-alpha";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NuvioMedia";
    repo = "NuvioDesktop";
    tag = finalAttrs.version;
    hash = "sha256-eg5PFnNs1jwkzxKUjXTT+5tTqtvjNjcqnn2B9ELAbV4=";
  };

  patches = [
    # build fails if native deps are present
    ./patches/fix-build.patch

    # experimental linux player support
    ./patches/pr-142-linux-gpu-player.patch

    # allow using external player via xdg-open
    ./patches/enable-external-player.patch

    # hack: build fails due to unneeded android deps
    # (wouldnt build without android sdk and sentry otherwise, i might be doing sth wrong though)
    ./patches/remove-mobile-deps.patch
  ];
  postPatch = ''
    # remove android/ios remnants
    shopt -s extglob nullglob
    rm -rf ./androidApp ./iosApp/!(Configuration)

    # set gradle props
    cp --no-preserve=mode ${./local.properties} local.properties
    echo "kotlin.native.ignoreDisabledTargets=true" >> ./local.properties
    echo "kotlin.native.enableKlibsCrossCompilation=false" >> ./local.properties
  '';

  nativeBuildInputs = [
    gradle
    autoPatchelfHook
    makeBinaryWrapper
    # (gtk3 is only used for native popups and such, not the main window, which is skia)
    # nice to wrap it so that works properly, but not absolutely required
    wrapGAppsHook3
    imagemagick
    copyDesktopItems
    pkg-config
  ];
  buildInputs = [
    libGL
    libx11
    gtk3
    libgbm
    mpv
    fontconfig
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true; # (required for mitmCache)

  gradleBuildTask = ":composeApp:createReleaseDistributable";
  gradleUpdateTask = finalAttrs.gradleBuildTask;
  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "--no-configuration-cache" # https://github.com/NixOS/nixpkgs/issues/381969
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Nuvio";
      desktopName = "Nuvio";
      genericName = "Media Client";
      comment = "Browse metadata and play streams from user-provided sources";
      exec = "Nuvio %u";
      tryExec = "Nuvio";
      icon = "Nuvio";
      terminal = false;
      type = "Application";
      categories = [
        "AudioVideo"
        "Video"
        "Player"
      ];
      keywords = [
        "media"
        "streaming"
        "video"
        "movies"
        "tv"
        "player"
      ];
      startupNotify = true;
      startupWMClass = "com-nuvio-app-MainKt";
      singleMainWindow = true;
      mimeTypes = [
        "x-scheme-handler/nuvio"
        "x-scheme-handler/stremio"
      ];
    })
  ];

  dontWrapGApps = true; # (adding gappsWrapperArgs manually)

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,bin,share}

    # copy lib/app and app icon
    cp -r --no-preserve=mode ./composeApp/build/compose/binaries/main-release/app/Nuvio/lib/{app,Nuvio.png} $out/lib

    # install slf4j into classpath to avoid warning on start
    install -Dm755 ${slf4j-simple} $out/lib/app/slf4j-simple.jar

    # main wrapper
    makeBinaryWrapper ${jre}/bin/java $out/bin/Nuvio \
      --inherit-argv0 \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --set JAVA_HOME ${jre.home} \
      --set MPV_HOME /tmp \
      --add-flags "-Djava.library.path=$out/lib/app:${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --add-flags "-Djpackage.app-version=${finalAttrs.version}" \
      --add-flags "-Dcompose.application.resources.dir=$out/lib/app/resources" \
      --add-flags "-Dcompose.application.configure.swing.globals=true" \
      --add-flags "-Dskiko.library.path=$out/lib/app" \
      --add-flags "-Dnuvio.torrserver.binary=${lib.getBin torrserver}/bin/torrserver" \
      --add-flags "--add-opens=java.desktop/java.awt=ALL-UNNAMED" \
      --add-flags "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-cp" \
      --add-flags "$out/lib/app/*" \
      --add-flags "com.nuvio.app.MainKt" \
      ''${gappsWrapperArgs[@]};

    # shipped icon has weird resolution, just resize it into bunch of more common ones
    for size in 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps;
      magick $out/lib/Nuvio.png -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/Nuvio.png;
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Media client for browsing metadata and playing streams from user-provided sources";
    longDescription = ''
      ⚠️ Alpha Software - Testers Only

      Nuvio is an open-source media center and library companion for browsing your libraries, profiles, watch progress, and account-connected details across mobile, tablet, TV, desktop, and WebOS.

      The app focuses on polished presentation, fast navigation, profile sync, and integrations you control.
    '';
    homepage = "https://github.com/NuvioMedia/NuvioDesktop";
    changelog = "https://github.com/NuvioMedia/NuvioDesktop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm-cache, bundled jars, slf4j-simple.jar
      binaryNativeCode # some deps bundle native libraries
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux; # TODO: darwin support
    mainProgram = "Nuvio";
  };
})
