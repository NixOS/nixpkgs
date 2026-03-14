{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "arduino-ide";
  version = "2.3.7";

  src = fetchurl {
    url = "https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_Linux_64bit.AppImage";
    hash = "sha256-m4RYtjJMZ01M1qwKc70Gkey9QLQ4Gk59rwpunm4TY2g=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/arduino-ide.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/arduino-ide.png -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/arduino-ide.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=arduino-ide %U'
  '';

  extraPkgs = pkgs: [ pkgs.libsecret ];

  meta = {
    description = "Open-source electronics prototyping platform";
    homepage = "https://www.arduino.cc/en/software";
    changelog = "https://github.com/arduino/arduino-ide/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "arduino-ide";
    maintainers = with lib.maintainers; [ clerie ];
    platforms = [ "x86_64-linux" ];
  };
}
