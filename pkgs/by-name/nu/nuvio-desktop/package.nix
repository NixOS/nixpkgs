{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  gradle_9,
  jdk17_headless,
  jre17_minimal,
  autoPatchelfHook,
  cmake,
  imagemagick,
  makeBinaryWrapper,
  pkg-config,
  wrapGAppsHook3,
  fontconfig,
  glib-networking,
  gst_all_1,
  gtk3,
  libGL,
  libgbm,
  libx11,
  libxcomposite,
  libxext,
  mpv-unwrapped,
  webkitgtk_4_1,
  xdg-utils,
  nuvio-engine,
}:
let
  gradle = gradle_9;
  jre = jre17_minimal.override {
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
      "jdk.accessibility"
      "jdk.crypto.ec"
      "jdk.httpserver"
      "jdk.unsupported"
    ];
  };
  slf4j-simple = fetchurl {
    url = "mirror://maven/org/slf4j/slf4j-simple/2.0.17/slf4j-simple-2.0.17.jar";
    hash = "sha256-3f6lmsB0xtPiSsLDhiLS2WOJXhf3CzjtS9rk14C+aWQ=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nuvio-desktop";
  version = "0.1.30-alpha";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NuvioMedia";
    repo = "NuvioDesktop";
    tag = finalAttrs.version;
    hash = "sha256-NWI9sBRrHg/VOINNWQqs6u4fT0gZlaw7VSRmejcNKGM=";
  };

  postPatch = ''
    substituteInPlace composeApp/src/desktopMain/kotlin/com/nuvio/app/core/build/AppFeaturePolicy.desktop.kt \
      --replace-fail 'inAppUpdaterEnabled: Boolean = true' 'inAppUpdaterEnabled: Boolean = false' \
      --replace-fail 'externalPlayerSupported: Boolean = false' 'externalPlayerSupported: Boolean = true'

    substituteInPlace scripts/linux/linux-shortcut-definition.sh \
      --replace-fail "usr/share/applications/" "share/applications/"

    # remove vendored bins
    rm -r composeApp/src/desktopMain/native/{linux/engine,macos,windows}

    # set gradle props
    cp --no-preserve=mode ${./local.properties} local.properties
  '';

  nativeBuildInputs = [
    gradle
    autoPatchelfHook
    cmake # (for native player bridge)
    imagemagick
    makeBinaryWrapper
    pkg-config
    wrapGAppsHook3
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    fontconfig
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    gtk3
    libGL
    libgbm
    libx11
    libxcomposite
    libxext
    mpv-unwrapped
    webkitgtk_4_1
    stdenv.cc.cc.lib # libskiko
  ];

  env.JAVA_HOME = gradle.jdk.home;

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  gradleBuildTask = ":composeApp:createReleaseDistributable";
  gradleUpdateTask = "${finalAttrs.gradleBuildTask} -x :composeMediaPlayer:buildNativeLinux";
  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "--no-configuration-cache" # https://github.com/NixOS/nixpkgs/issues/381969
    "-Pkotlin.native.ignoreDisabledTargets=true"
    "-Pkotlin.native.enableKlibsCrossCompilation=false"
    "-Dorg.gradle.java.home=${jdk17_headless.home}"
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share/{applications,metainfo,icons}}

    appDir=composeApp/build/compose/binaries/main-release/app/Nuvio/lib
    cp -r $appDir/app $out/lib/

    install -Dm644 ${slf4j-simple} $out/lib/app/slf4j-simple.jar

    mkdir -p $out/lib/app/resources/native/linux
    ln -s ${nuvio-engine}/lib/libnuvio_engine.so $out/lib/app/resources/native/linux/libnuvio_engine.so

    install -Dm644 scripts/linux/com.nuvio.media.desktop.metainfo.xml $out/share/metainfo/com.nuvio.media.desktop.metainfo.xml

    source scripts/linux/linux-shortcut-definition.sh
    nuvio_linux_write_desktop_entry_file \
      "$out/share/applications/com.nuvio.media.desktop.desktop" \
      "nuvio %u" \
      "com.nuvio.media.desktop"

    # icon has unusual resolution
    for size in 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      magick $appDir/Nuvio.png -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/com.nuvio.media.desktop.png
    done

    # compose.desktop.application.jvmArgs
    makeBinaryWrapper ${jre}/bin/java $out/bin/nuvio \
      --inherit-argv0 \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --set JAVA_HOME ${jre.home} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Djava.library.path=${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --add-flags "-Djpackage.app-version=${finalAttrs.version}" \
      --add-flags "-Dcompose.application.resources.dir=$out/lib/app/resources" \
      --add-flags "-Dcompose.application.configure.swing.globals=true" \
      --add-flags "-Dskiko.library.path=$out/lib/app" \
      --add-flags "-Djdk.gtk.version=0" \
      --add-flags "--add-opens=java.desktop/java.awt=ALL-UNNAMED" \
      --add-flags "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flag "-cp" \
      --add-flag "$out/lib/app/*" \
      --add-flag "com.nuvio.app.MainKt"

    runHook postInstall
  '';

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Free, open-source media app for your phone, your desktop, and the TV you already own";
    longDescription = ''
      A free, open-source media app for your phone, your desktop, and the TV you already own.

      Bring your own sources. Nuvio turns them into a library with artwork, ratings, subtitles, and your place saved on every screen.
    '';
    homepage = "https://nuvio.tv";
    downloadPage = "https://github.com/NuvioMedia/NuvioDesktop/releases";
    changelog = "https://github.com/NuvioMedia/NuvioDesktop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # gradle dependencies, slf4j-simple
      binaryNativeCode # libskiko
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux; # TODO: darwin
    mainProgram = "nuvio";
  };
})
