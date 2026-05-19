# Generic builder for shattered pixel forks/mods
{
  pname,
  version,
  src,
  meta,
  desktopName,
  patches ? [ ./disable-beryx.patch ],
  depsPath ? null,
  sourceRoot ? null,
  nativeBuildInputs ? [ ],
  passthru ? { },
  postPatch ? "",

  lib,
  stdenv,
  makeWrapper,
  gradle_8,
  perl,
  jre,
  libGL,
  libpulseaudio,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    patches
    ;

  inherit sourceRoot;

  mitmCache = gradle_8.fetchDeps {
    inherit pname;
    data = if depsPath != null then depsPath else ./. + "/${pname}/deps.json";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    gradle_8
    perl
    makeWrapper
    copyDesktopItems
  ]
  ++ nativeBuildInputs;

  gradleBuildTask = "desktop:release";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      inherit desktopName;
      comment = meta.description;
      icon = pname;
      exec = pname;
      terminal = false;
      categories = [
        "Game"
        "AdventureGame"
      ];
      keywords = [
        "roguelike"
        "dungeon"
        "crawler"
      ];
    })
  ];

  postPatch = ''
    # disable gradle plugins with native code and their targets
    perl -i.bak1 -pe "s#(^\s*id '.+' version '.+'$)#// \1#" build.gradle
    perl -i.bak2 -pe "s#(.*)#// \1# if /^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar|robovm|git-version)/ ... /^}/" build.gradle
    # Remove unbuildable Android/iOS stuff
    rm -f android/build.gradle ios/build.gradle
  ''
  + postPatch;

  installPhase = ''
    runHook preInstall

    install -Dm644 desktop/build/libs/desktop-*.jar $out/share/${pname}.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libpulseaudio
        ]
      } \
      --add-flags "-jar $out/share/${pname}.jar"

    for s in 16 32 48 64 128 256; do
      # Some forks only have some icons and/or name them slightly differently
      if [ -f desktop/src/main/assets/icons/icon_$s.png ]; then
        install -Dm644 desktop/src/main/assets/icons/icon_$s.png \
          $out/share/icons/hicolor/''${s}x$s/apps/${pname}.png
      fi
      if [ -f desktop/src/main/assets/icons/icon_''${s}x$s.png ]; then
        install -Dm644 desktop/src/main/assets/icons/icon_''${s}x$s.png \
          $out/share/icons/hicolor/''${s}x$s/apps/${pname}.png
      fi
    done

    runHook postInstall
  '';

  inherit passthru;

  meta = lib.recursiveUpdate {
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = pname;
  } meta;
})
