{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "clockify";
  version = "2.3.2.2633";

  src = fetchurl {
    url = "https://web.archive.org/web/20250419021523/https://clockify.me/downloads/Clockify_Setup.AppImage";
    hash = "sha256-cQP1QkF2uWGsCjYjVdxPFLL8atAjT6rPQbPqeNX0QqQ=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm 444 ${appimageContents}/clockify.desktop -t $out/share/applications
      install -Dm 444 ${appimageContents}/clockify.png -t $out/share/pixmaps

      substituteInPlace $out/share/applications/clockify.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = {
    description = "Free time tracker and timesheet app that lets you track work hours across projects";
    homepage = "https://clockify.me";
    license = lib.licenses.unfree;
    maintainers = [ ];
    mainProgram = "clockify";
    platforms = [ "x86_64-linux" ];
  };
}
