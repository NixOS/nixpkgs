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
  imagemagick,
}:

let
  version = "2.0.04";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
    hash = "sha256-Vk5USCXyys9ogP6g6RZbd9CzyfUv8R+agrO2Vl97Mr8=";
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

in
maven.buildMavenPackage rec {
  pname = "forge-mtg";
  inherit version src patches;

  mvnHash = "sha256-5mj7W1m/iGe/Fy2dpiy+7cdqZGAo4cbtOUvMh7eEhbU=";

  doCheck = false; # Needs a running Xorg

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];
  desktopItem = makeDesktopItem {
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
  };

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

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons/hicolor/128x128/apps
    convert AppIcon.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/forge-mtg.png

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

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://card-forge.github.io/forge";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
