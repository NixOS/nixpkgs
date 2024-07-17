{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "arduino-ide";
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_Linux_64bit.AppImage";
    hash = "sha256-M7JKfld6DRk4hxih5MufAhW9kJ+ePDrBhE+oXFc8dYw=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
    substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
  '';

  extraPkgs = pkgs: [ pkgs.libsecret ];

  meta = with lib; {
    description = "Open-source electronics prototyping platform";
    homepage = "https://www.arduino.cc/en/software";
    changelog = "https://github.com/arduino/arduino-ide/releases/tag/${version}";
    license = licenses.agpl3Only;
    mainProgram = "arduino-ide";
    maintainers = with maintainers; [ clerie ];
    platforms = [ "x86_64-linux" ];
  };
}
