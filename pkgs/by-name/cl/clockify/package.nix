{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "clockify";
  version = "2.2.9.2224";

  src = fetchurl {
    url = "https://web.archive.org/web/20241218115559/https://clockify.me/downloads/Clockify_Setup.AppImage";
    hash = "sha256-/L70C+sTFJPzXkt1NSak2wVTRtFy2zInIlmLPG5LqeY=";
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
