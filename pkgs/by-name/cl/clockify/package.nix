{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "clockify";
  version = "2.3.2.2633";

  src = fetchurl {
    url = "https://web.archive.org/web/20250419021523/https://clockify.me/downloads/Clockify_Setup.AppImage";
    hash = "sha256-cQP1QkF2uWGsCjYjVdxPFLL8atAjT6rPQbPqeNX0QqQ=";
  };

  extraInstallCommands = ''
    install -Dm 444 ${finalAttrs.contents}/clockify.desktop -t $out/share/applications
    install -Dm 444 ${finalAttrs.contents}/clockify.png -t $out/share/icons

    substituteInPlace $out/share/applications/clockify.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=clockify'
  '';

  meta = {
    description = "Free time tracker and timesheet app that lets you track work hours across projects";
    homepage = "https://clockify.me";
    license = lib.licenses.unfree;
    maintainers = [ ];
    mainProgram = "clockify";
    platforms = [ "x86_64-linux" ];
  };
})
