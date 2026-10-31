{
  stdenvNoCC,
  lib,
  fetchzip,
  openjfx21,
  openjdk21,
  makeDesktopItem,
  wrapGAppsHook3,
  makeBinaryWrapper,
}:

let
  openjfx_jdk = openjfx21.override { withWebKit = true; };
  openjdk = openjdk21.override {
    enableJavaFX = true;
    inherit openjfx_jdk;
  };

  # Wrapper class to bypass "JavaFX runtime components are missing" error
  # which occurs when the main entrypoint class directly extends Application.
  # This fix was mentioned in https://www.reddit.com/r/JavaFX/comments/k7aa9q/javafx_error_error_javafx_runtime_components_are

  launcherSrc = builtins.toFile "Launcher.java" ''
    public class Launcher {
        public static void main(String[] args) {
            gg.minion.Minion.main(args);
        }
    }
  '';
in
stdenvNoCC.mkDerivation rec {
  pname = "minion";
  version = "3.0.12";

  src = fetchzip {
    url = "https://cdn.mmoui.com/minion/v3/Minion${version}-java.zip";
    hash = "sha256-KjSj3TBMY3y5kgIywtIDeil0L17dau/Rb2HuXAulSO8=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  buildPhase = ''
    runHook preBuild

    cp ${launcherSrc} Launcher.java

    JFX_MODULES="${openjfx_jdk}/modules/javafx.base:${openjfx_jdk}/modules/javafx.controls:${openjfx_jdk}/modules/javafx.graphics:${openjfx_jdk}/modules/javafx.fxml:${openjfx_jdk}/modules/javafx.web:${openjfx_jdk}/modules/javafx.media:${openjfx_jdk}/modules/javafx.swing"

    ${openjdk}/bin/javac -cp "Minion-jfx.jar:lib/*:$JFX_MODULES" Launcher.java -d .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/minion"

    install -D Launcher.class "$out/share/minion/Launcher.class"
    install -D Minion-jfx.jar "$out/share/minion/Minion-jfx.jar"
    cp -r ./lib "$out/share/minion/"

    runHook postInstall
  '';

  # gappsWrapperArgs is populated during fixupPhase, so makeWrapper must run in preFixup.
  # Reference: https://ryantm.github.io/nixpkgs/languages-frameworks/gnome/
  # JFX_NATIVE prevents "Graphics Device initialization failed" errors.

  preFixup = ''
    JFX_MODULES="${openjfx_jdk}/modules/javafx.base:${openjfx_jdk}/modules/javafx.controls:${openjfx_jdk}/modules/javafx.graphics:${openjfx_jdk}/modules/javafx.fxml:${openjfx_jdk}/modules/javafx.web:${openjfx_jdk}/modules/javafx.media:${openjfx_jdk}/modules/javafx.swing"
    JFX_NATIVE="${openjfx_jdk}/modules_libs/javafx.graphics:${openjfx_jdk}/modules_libs/javafx.web:${openjfx_jdk}/modules_libs/javafx.media"

    makeWrapper ${lib.getExe openjdk} $out/bin/minion \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "-Djava.library.path=$JFX_NATIVE" \
      --add-flags "-cp $out/share/minion:$out/share/minion/Minion-jfx.jar:$out/share/minion/lib/*:$JFX_MODULES" \
      --add-flags "--add-opens=java.base/java.lang=ALL-UNNAMED" \
      --add-flags "--add-exports=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED" \
      --add-flags "--add-exports=javafx.graphics/javafx.scene.image=ALL-UNNAMED" \
      --add-flags "--add-opens=javafx.graphics/javafx.scene.image=ALL-UNNAMED" \
      --add-flags "Launcher"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "minion";
      exec = "minion";
      comment = "MMO Addon manager for Elder Scrolls Online and World of Warcraft";
      desktopName = "Minion";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Addon manager for World of Warcraft and The Elder Scrolls Online";
    homepage = "https://minion.mmoui.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "minion";
    maintainers = with lib.maintainers; [ patrickdag ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
