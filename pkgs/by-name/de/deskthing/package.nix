{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "0.10.3";
  pname = "deskthing";

  src = fetchurl {
    url = "https://github.com/ItsRiprod/DeskThing/releases/download/v${version}-beta/deskthing-linux-${version}-setup.AppImage";
    hash = "sha256-6MX1SeeZu3aLuqHaR94UMGfJ5IcgVSMseCay45no2Ts=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  #extraInstallCommands = ''
  #  substituteInPlace $out/share/applications/${pname}.desktop \
  #    --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  #'';

  meta = {
    description = "Configuration tool for the DeskThing";
    homepage = "https://github.com/ItsRiprod/DeskThing";
    downloadPage = "https://github.com/ItsRiprod/DeskThing/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ quentin ];
    mainProgram = "deskthing";
    platforms = [ "x86_64-linux" ];
  };
}
