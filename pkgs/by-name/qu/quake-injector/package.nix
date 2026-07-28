{
  lib,
  stdenv,
  jre,
  makeWrapper,
  jdk,
  makeDesktopItem,
  copyDesktopItems,
  fetchzip,
  fetchurl,
}:
let
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/hrehfeld/QuakeInjector/b741bae9904acbf2e18cdb1ca8e71a12e7d416cf/src/main/resources/Inject2_256.png";
    hash = "sha256-769YoSJ52+BTk7s+wh4oOyHwPPrR7AeOxCS58CdQ93s=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "quake-injector";
  version = "08";

  src = fetchzip {
    url = "https://github.com/hrehfeld/QuakeInjector/releases/download/alpha${finalAttrs.version}/QuakeInjector-alpha${finalAttrs.version}.zip";
    hash = "sha256-u2Ir7KxptgX9hcCf0GECl/z2+qSfHUdMgCoN8qbQMUs=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase =
    let
      # Explicit needed JAR filenames
      filenames = [
        "QuakeInjector-alpha${finalAttrs.version}.jar"
        "BrowserLauncher2-1.3.jar"
        "jackson-annotations-2.13.3.jar"
        "jackson-core-2.13.3.jar"
        "jackson-databind-2.13.3.jar"
        "commons-compress-1.27.1.jar"
        "darklaf-core-2.7.3.jar"
        "commons-codec-1.17.1.jar"
        "commons-io-2.16.1.jar"
        "commons-lang3-3.16.0.jar"
        "darklaf-windows-2.7.3.jar"
        "darklaf-macos-2.7.3.jar"
        "darklaf-theme-2.7.3.jar"
        "darklaf-property-loader-2.7.3.jar"
        "darklaf-native-utils-2.7.3.jar"
        "darklaf-utils-2.7.3.jar"
        "darklaf-platform-base-2.7.3.jar"
        "swing-extensions-laf-support-0.1.3.jar"
        "svgSalamander-1.1.2.4.jar"
        "swing-extensions-visual-padding-0.1.3.jar"
        "annotations-16.0.2.jar"
      ];

      mkClasspath = prefix: lib.concatMapStringsSep ":" (filename: "${prefix}/${filename}") filenames;
      classpath = mkClasspath "$out/share/quake-injector";
    in
    ''
      runHook preInstall

      mkdir -p $out/{bin,share/quake-injector}
      cp lib/*.jar $out/share/quake-injector

      mkdir -p $out/share/icons/hicolor/256x256/apps
      cp ${icon} $out/share/icons/hicolor/256x256/apps/quake-injector.png

      makeWrapper ${jre}/bin/java $out/bin/quake-injector \
        --add-flags "-classpath ${classpath} de.haukerehfeld.quakeinjector.QuakeInjector"

      runHook postInstall
    '';

  # There are no tests.
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "quake-injector";
      exec = finalAttrs.meta.mainProgram;
      icon = "quake-injector";
      comment = finalAttrs.meta.description;
      desktopName = "Quake Injector";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Download, install and play quake singleplayer maps from the quaddicted.com archive";
    homepage = "https://github.com/hrehfeld/QuakeInjector";
    changelog = "https://github.com/hrehfeld/QuakeInjector/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "quake-injector";
    platforms = jdk.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
})
