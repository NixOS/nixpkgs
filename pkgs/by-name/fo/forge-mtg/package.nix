{
  coreutils,
  fetchFromGitHub,
  gnused,
  lib,
  maven,
  makeWrapper,
  openjdk,
}:

let
  version = "1.6.65";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
    hash = "sha256-MCJl3nBHbX/O24bzD4aQ12eMWxYY2qJC5vomvtsIBek=";
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

in
maven.buildMavenPackage {
  pname = "forge-mtg";
  inherit version src patches;

  mvnHash = "sha256-ouF0Ja3oGrlUCcT0PzI5i9FQ+oLdEhE/LvhJ0QGErvI=";

  doCheck = false; # Needs a running Xorg

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge
    cp -a \
      forge-gui-desktop/target/forge.sh \
      forge-gui-desktop/target/forge-gui-desktop-${version}-jar-with-dependencies.jar \
      forge-gui-mobile-dev/target/forge-adventure.sh \
      forge-gui-mobile-dev/target/forge-gui-mobile-dev-${version}-jar-with-dependencies.jar \
      forge-adventure/target/forge-adventure-editor.sh \
      forge-adventure/target/forge-adventure-${version}-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            openjdk
            gnused
          ]
        } \
        --set JAVA_HOME ${openjdk}/lib/openjdk \
        --set SENTRY_DSN ""
    done
  '';

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://www.slightlymagic.net/forum/viewforum.php?f=26";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
