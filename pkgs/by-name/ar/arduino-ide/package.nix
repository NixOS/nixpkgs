{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "arduino-ide";
  version = "2.3.6";

  src = fetchurl {
    url = "https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_Linux_64bit.AppImage";
    hash = "sha256-3Zx6XRhkvAt1Erv13wF3p3lm3guRDYreh+ATBzoO6pk=";
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

  meta = {
    description = "Open-source electronics prototyping platform";
    homepage = "https://www.arduino.cc/en/software";
    changelog = "https://github.com/arduino/arduino-ide/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "arduino-ide";
    maintainers = with lib.maintainers; [
      clerie
      iedame
    ];
    platforms = [ "x86_64-linux" ];
  };
}
