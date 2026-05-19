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
    # Disable gradle plugins with native code and their targets
    sed -i -E "s#^(\s*id '.+' version '.+')$#// \1#" build.gradle
    # Comment out build blocks incompatible with this build (platform-specific packaging, etc.)
    sed -i -E '/^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar|robovm|git-version)/,/^\}/{s/.*/\/\/ &/}' build.gradle
    # Remove unbuildable Android/iOS stuff
    rm -f android/build.gradle ios/build.gradle
  ''
  + postPatch;

  installPhase = ''
    runHook preInstall

    install -Dm644 desktop/build/libs/desktop-*.jar $out/share/${pname}.jar
    mkdir $out/bin

    # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      app="$out/Applications/${builtins.replaceStrings [ "/" ] [ ":" ] desktopName}.app"
      mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources" "$app/Contents/Java"

      cp ios/Info.plist "$app/Contents/Info.plist"
      substituteInPlace "$app/Contents/Info.plist" \
        --replace-fail '${"$"}{appName}' "${desktopName}" \
        --replace-fail '${"$"}{appExecutable}' "launcher.sh" \
        --replace-fail '${"$"}{appApplePackageName}' "com.shatteredpixel.${pname}" \
        --replace-fail '${"$"}{appShortVersionName}' "${version}" \
        --replace-fail '${"$"}{appVersionName}' "${version}" \
        --replace-fail '${"$"}{appVersionCode}' "${version}"

      # Insert additional plist keys before the closing </dict> tag
      awk '/<\/dict>/{
        print "    <key>CFBundleIconFile</key>"
        print "    <string>mac.icns</string>"
        print "    <key>LSMinimumSystemVersion</key>"
        print "    <string>10.9.0</string>"
        print "    <key>LSApplicationCategoryType</key>"
        print "    <string>public.app-category.role-playing-games</string>"
        print "    <key>NSHighResolutionCapable</key>"
        print "    <true/>"
        print "    <key>NSHumanReadableCopyright</key>"
        print "    <string>Copyright Evan Debenham</string>"
      } { print }' "$app/Contents/Info.plist" > "$app/Contents/Info.plist.tmp"
      mv "$app/Contents/Info.plist.tmp" "$app/Contents/Info.plist"

      ln -s "$out/share/${pname}.jar" "$app/Contents/Java/${pname}.jar"

      cp desktop/src/main/assets/icons/mac.icns "$app/Contents/Resources/mac.icns"

      makeWrapper ${lib.getExe jre} "$app/Contents/MacOS/launcher.sh" \
        --add-flag "-XstartOnFirstThread" \
        --add-flag "-jar" \
        --add-flag "$app/Contents/Java/${pname}.jar"

      ln -s "$app/Contents/MacOS/launcher.sh" "$out/bin/${pname}"
    ''}

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      makeWrapper ${lib.getExe jre} $out/bin/${pname} \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libGL
            libpulseaudio
          ]
        } \
        --add-flags "-jar $out/share/${pname}.jar"
    ''}

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
