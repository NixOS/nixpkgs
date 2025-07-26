{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  imagemagick,
}:
let
  pname = "deskthing";
  version = "0.11.10";

  src = fetchurl {
    url = "https://github.com/ItsRiprod/${pname}/releases/download/v${version}/deskthing-linux-${version}-setup.AppImage";
    hash = "sha256-NTUcqdJGdIwydZZU6AS+buJwZES3IHkD6pAL85ECunk=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    # install "0x0" icon as 512x512
    install -m 444 -D \
      ${appimageContents}/usr/share/icons/hicolor/0x0/apps/deskthing.png \
      $out/share/icons/hicolor/512x512/apps/deskthing.png
  '';

  extraPkgs =
    pkgs: with pkgs; [
      vips
    ];

  meta = {
    homepage = "https://deskthing.app/";
    downloadPage = "https://github.com/ItsRiprod/${pname}/releases/";
    description = "DeskThing desktop companion app";
    mainProgram = "deskthing";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malmeloo ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
