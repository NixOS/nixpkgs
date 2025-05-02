{ lib
, appimageTools
, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "clockify";
  version = "2.1.17.1354";

  src = fetchurl {
    url = "https://web.archive.org/web/20240406052908/https://clockify.me/downloads/Clockify_Setup.AppImage";
    hash = "sha256-G5VOAf6PrjHUsnk7IlXdqJ2D941cnggjuHkkgrOaVaA=";
  };

  extraInstallCommands =
    let appimageContents = appimageTools.extract { inherit pname version src; };
    in ''
      install -Dm 444 ${appimageContents}/clockify.desktop -t $out/share/applications
      install -Dm 444 ${appimageContents}/clockify.png -t $out/share/pixmaps

      substituteInPlace $out/share/applications/clockify.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "Free time tracker and timesheet app that lets you track work hours across projects";
    homepage = "https://clockify.me";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "clockify";
    platforms = [ "x86_64-linux" ];
  };
}
