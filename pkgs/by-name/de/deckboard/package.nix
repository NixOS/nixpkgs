{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  nix-update-script,
  ...
}:
appimageTools.wrapType2 rec {
  pname = "deckboard";
  version = "3.1.4";
  src = fetchurl {
    url = "https://github.com/rivafarabi/deckboard/releases/download/v${version}/Deckboard-${version}.AppImage";
    hash = "sha256-BNrpxI7c7o5Tx6RhbwNUnqs9Yax64dj3flMQnOw5BK8=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraBwrapArgs = [
    "--bind-try /etc/nixos/ /etc/nixos/"
  ];

  extraPkgs =
    pkgs: with pkgs; [
      unzip
      autoPatchelfHook
      asar
      (buildPackages.wrapGAppsHook3.override { inherit makeWrapper; })
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Stream-deck alternative that turns tablet devices into a stream deck";
    homepage = "https://deckboard.app/";
    changelog = "https://github.com/rivafarabi/deckboard/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      eveeifyeve
      guildedthorn
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "deckboard";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
