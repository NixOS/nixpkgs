{
  lib,
  stdenv,
  copyDesktopItems,
  fetchFromGitHub,
  jdk,
  jre,
  makeDesktopItem,
  makeWrapper,
  stripJavaArchivesHook,
  nix-update-script,
}:

let
  runtimeLibraries = [
    "xuggle-xuggler-server-all.jar"
    "logback-classic.jar"
    "logback-core.jar"
    "slf4j-api.jar"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "osp-tracker";
  version = "6.3.5";

  strictDeps = true;
  __structuredAttrs = true;

  srcs = [
    (fetchFromGitHub {
      name = "tracker";
      owner = "OpenSourcePhysics";
      repo = "tracker";
      tag = "version_${finalAttrs.version}";
      hash = "sha256-FHjQ6ey9Zl9t6+SXmzqiDlZ2nR7nYIB0bL8IWGjmVo4=";
    })
    (fetchFromGitHub {
      name = "osp";
      owner = "OpenSourcePhysics";
      repo = "osp";
      tag = "version_${finalAttrs.version}";
      hash = "sha256-wFdVte0GaY+B4sIfAlcr9Y48ecKOOPDB7rB2dQxjWz8=";
    })
  ];
  sourceRoot = ".";

  nativeBuildInputs = [
    copyDesktopItems
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    # only build library sources, excluding demos and tests
    mkdir -p classes
    find osp/src/{org,javajs,swingjs} tracker/src/org -name '*.java' > java-sources.txt
    javac -d classes -encoding UTF-8 \
      -classpath tracker/libraries/xuggle-xuggler-server-all.jar \
      @java-sources.txt

    # resources are read from the classpath
    cp -r osp/src/{org,javajs,swingjs} tracker/src/org classes/
    find classes -name '*.java' -delete

    cat > tracker.mf <<'EOF'
    Main-Class: org.opensourcephysics.cabrillo.tracker.Tracker
    Class-Path: . ${lib.concatStringsSep " " runtimeLibraries}
    permissions: all-permissions
    EOF

    jar --create --file tracker.jar --manifest tracker.mf -C classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    shareDir=$out/share/java/osp-tracker
    install -Dm444 tracker.jar $shareDir/tracker.jar
    install -Dm444 tracker/LICENSE $out/share/licenses/osp-tracker/LICENSE

    classpath=$shareDir/tracker.jar
    for library in ${lib.escapeShellArgs runtimeLibraries}; do
      install -Dm444 tracker/libraries/$library $shareDir/$library
      classpath=$classpath:$shareDir/$library
    done

    # without TRACKER_HOME, the app tries to relaunch itself
    makeWrapper ${lib.getExe jre} $out/bin/tracker \
      --add-flags "-classpath $classpath" \
      --add-flags org.opensourcephysics.cabrillo.tracker.Tracker \
      --set TRACKER_HOME $shareDir

    install -Dm444 \
      tracker/src/org/opensourcephysics/cabrillo/tracker/resources/images/tracker_icon_256.png \
      $out/share/icons/hicolor/256x256/apps/osp-tracker.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "osp-tracker";
      desktopName = "Tracker";
      comment = finalAttrs.meta.description;
      exec = "tracker %f";
      icon = "osp-tracker";
      categories = [
        "Education"
        "Physics"
      ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=version_(.+)" ];
  };

  meta = {
    description = "Video analysis and modeling tool built on the Open Source Physics framework";
    homepage = "https://opensourcephysics.github.io/tracker-website/";
    license = lib.licenses.gpl3Plus;
    # Xuggle video engine is a prebuilt jar containing native code
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "tracker";
    # native code only exists for x86_64 Linux, macOS and Windows
    platforms = [ "x86_64-linux" ];
  };
})
