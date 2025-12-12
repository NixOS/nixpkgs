{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "mockoon";
  version = "9.3.0";

  src = fetchurl {
    url = "https://github.com/mockoon/mockoon/releases/download/v${version}/mockoon-${version}.x86_64.AppImage";
    hash = "sha256-KdhI8wJZLEAuGOiZa6sZ4+4+iNBOENsebYSVl9AYBEE=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Easiest and quickest way to run mock APIs locally";
    longDescription = ''
      Mockoon is the easiest and quickest way to run mock APIs locally.
      No remote deployment, no account required, free and open-source.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    homepage = "https://mockoon.com";
    changelog = "https://github.com/mockoon/mockoon/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "mockoon";
    platforms = [ "x86_64-linux" ];
  };
}
