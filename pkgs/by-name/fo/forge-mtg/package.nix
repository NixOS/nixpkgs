{
  coreutils,
  fetchFromGitHub,
  gnused,
  lib,
  maven,
  makeWrapper,
  openjdk,
  libGL,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  nix-update-script,
}:

let
  version = "2.0.05";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
    hash = "sha256-71CZBI4FvN5X7peDjhv+0cdTYv8hWwzM8ePdvQSb6QI=";
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

in
maven.buildMavenPackage {
  pname = "forge-mtg";
  inherit version src patches;

  mvnHash = "sha256-krPOUaJTo5i3imkDvEkBJH3W01y1KypdvitqmZ5JMMA=";

  doCheck = false; # Needs a running Xorg

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    imagemagick
  ];
  desktopItems = [
    (makeDesktopItem {
      name = "forge";
      exec = "forge";
      actions = {
        forge-adventure = {
          exec = "forge-adventure";
          name = "Play Adventure";
        };
        forge-adventure-editor = {
          exec = "forge-adventure-editor";
          name = "Adventure Editor";
        };
        forge-classic = {
          exec = "forge";
          name = "Play Classic";
        };
      };
      icon = "forge-mtg";
      comment = "Magic: the Gathering card game with rules enforcement";
      desktopName = "Forge MTG";
      genericName = "Card Game";
      categories = [
        "Game"
        "BoardGame"
      ];
      keywords = [
        "Magic"
        "MTG"
        "Card Game"
        "Trading Card Game"
        "TCG"
      ];
    })
  ];

  mvnParameters = lib.escapeShellArgs [
    "-pl"
    ":adventure-editor,:forge-gui-desktop,:forge-gui-mobile-dev" # forge-gui-mobile-dev is required for forge-adventure
    "--also-make"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge
    cp -a \
      forge-gui-desktop/target/forge.sh \
      forge-gui-desktop/target/forge-gui-desktop-${version}-jar-with-dependencies.jar \
      forge-gui-mobile-dev/target/forge-adventure.sh \
      forge-gui-mobile-dev/target/forge-gui-mobile-dev-${version}-jar-with-dependencies.jar \
      adventure-editor/target/adventure-editor-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    cp adventure-editor/target/adventure-editor.sh $out/share/forge/forge-adventure-editor.sh

    mkdir -p $out/share/icons/hicolor/128x128/apps
    magick AppIcon.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/forge-mtg.png

    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      PREFIX_CMD=""
      if [ "$commandToInstall" = "forge-adventure" ]; then
        PREFIX_CMD="--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}"
      fi

      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            openjdk
            gnused
          ]
        } \
        --set JAVA_HOME ${openjdk}/lib/openjdk \
        --set SENTRY_DSN "" \
        $PREFIX_CMD
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://card-forge.github.io/forge";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
