{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:
let
  pname = "deskthing";
  version = "0.11.6";

  src = fetchurl {
    url = "https://github.com/ItsRiprod/${pname}/releases/download/v${version}/deskthing-linux-${version}-setup.AppImage";
    hash = "sha256-els9b0EaBREiiWPheARBMokuQwizUO2cNq5JrFQ7QPk=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
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
