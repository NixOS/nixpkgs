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

  jvmArgs = [
    "-cp $out/share/minion/lib"
    "--add-exports=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED"
    "--add-exports=javafx.graphics/javafx.scene.image=ALL-UNNAMED"
    "--add-opens=javafx.graphics/javafx.scene.image=ALL-UNNAMED"
    "--add-opens=java.base/java.lang=ALL-UNNAMED"
  ];
in
stdenvNoCC.mkDerivation rec {
  version = "3.0.12";
  pname = "minion";

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

  installPhase = ''
    runHook preInstall

    install -D Minion-jfx.jar "$out/share/minion/Minion-jfx.jar"
    cp -r ./lib "$out/share/minion/"

    makeWrapper ${lib.getExe openjdk} $out/bin/minion \
      "''${gappsWrapperArgs[@]}" \
      --add-flags "${lib.concatStringsSep " " jvmArgs} -jar $out/share/minion/Minion-jfx.jar"

    runHook postInstall
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
