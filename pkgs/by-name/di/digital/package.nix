{
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  jre,
  maven,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "digital";
  version = "0.31";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hneemann";
    repo = "Digital";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6XaM3U1x/yvoCrkJ2nMtBmj972gCFlWn3F4DM7TLWgw=";
  };

  # Use the "no-git-rev" maven profile, which deactivates the plugin that
  # inspect the .git folder to find the version number we are building, we then
  # provide that version number manually as a property.
  # (see https://github.com/hneemann/Digital/issues/289#issuecomment-513721481)
  # Also use the v0.31 commit date as a build and output timestamp.
  mvnParameters = "-Pno-git-rev -Dgit.commit.id.describe=${finalAttrs.version} -Dproject.build.outputTimestamp=2024-09-03T14:02:31+02:00 -DbuildTimestamp=2024-09-03T14:02:31+02:00";
  mvnHash = "sha256-qFJvpxK6PDmMfeL5fKVHUzK2NRLcQhQ3PJbwv2hYZqY=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/java target/Digital.jar

    # Install the lib folder containing 74xx series chips and other component libraries
    # Digital.jar expects to find lib/ in the same directory as the jar file
    cp -r src/main/dig/lib $out/share/java/

    makeWrapper ${lib.getExe jre} $out/bin/digital \
      --add-flags "-jar $out/share/java/Digital.jar"

    install -Dm644 src/main/svg/icon.svg $out/share/icons/hicolor/scalable/apps/digital.svg
    for size in 16 32 48 64 128; do
      install -Dm644 src/main/resources/icons/icon"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/digital.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "digital";
      desktopName = "Digital";
      comment = "Easy-to-use digital logic designer and circuit simulator";
      exec = "digital";
      icon = "digital";
      categories = [
        "Education"
        "Electronics"
      ];
      mimeTypes = [ "text/x-digital" ];
      terminal = false;
      keywords = [
        "simulator"
        "digital"
        "circuits"
      ];
    })
  ];

  meta = {
    homepage = "https://github.com/hneemann/Digital";
    description = "Digital logic designer and circuit simulator";
    changelog = "https://github.com/hneemann/Digital/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "digital";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      Dettorer
      miniharinn
    ];
  };
})
