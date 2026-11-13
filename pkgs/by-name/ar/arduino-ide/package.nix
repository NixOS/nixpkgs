{
  appimageTools,
  fetchurl,
  lib,
  python3,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "arduino-ide";
  version = "2.3.11";
  src = fetchurl {
    url = "https://github.com/arduino/arduino-ide/releases/download/${finalAttrs.version}/arduino-ide_${finalAttrs.version}_Linux_64bit.AppImage";
    hash = "sha256-8kP4+JTr7FDL3w5N7MTzHdFvIiVCUN5iQ+q4Dtg9OpA=";
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/arduino-ide.desktop -t $out/share/applications/
    install -Dm444 ${finalAttrs.contents}/arduino-ide.png -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/arduino-ide.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=arduino-ide %U'
  '';

  extraPkgs = pkgs: [
    pkgs.libsecret
    (python3.withPackages (ps: [
      ps.pyserial # for esptool
    ]))
  ];

  meta = {
    description = "Open-source electronics prototyping platform";
    homepage = "https://www.arduino.cc/en/software";
    changelog = "https://github.com/arduino/arduino-ide/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "arduino-ide";
    maintainers = with lib.maintainers; [ clerie ];
    platforms = [ "x86_64-linux" ];
  };
})
