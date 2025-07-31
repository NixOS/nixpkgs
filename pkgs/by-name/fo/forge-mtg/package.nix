{
  coreutils,
  fetchFromGitHub,
  gnused,
  lib,
  maven,
  makeWrapper,
  nix-update-script,
  openjdk,
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

  mvnHash = "sha256-HEcKPvNttQsG7Vip/N/sduK4uEDpQe8GsQwkOcATa38=";

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
      adventure-editor/target/adventure-editor.sh \
      adventure-editor/target/adventure-editor-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure adventure-editor; do
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=forge-(.*)" ];
  };

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://www.slightlymagic.net/forum/viewforum.php?f=26";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      eigengrau
      icetan
    ];
  };
}
