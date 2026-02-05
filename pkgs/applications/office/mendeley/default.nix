{
  lib,
  fetchurl,
  appimageTools,
  gconf,
  imagemagick,
}:

let
  pname = "mendeley";
  version = "2.142.0";

  executableName = "${pname}-reference-manager";

  src = fetchurl {
    url = "https://static.mendeley.com/bin/desktop/mendeley-reference-manager-${version}-x86_64.AppImage";
    hash = "sha256-Ic19MQRzRLmYL2nVFMBvCbloI0AoCm0MVlWJeV4i+Fs=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/$pname $out/bin/${executableName}
    install -m 444 -D ${appimageContents}/${executableName}.desktop $out/share/applications/${executableName}.desktop
    ${imagemagick}/bin/convert ${appimageContents}/${executableName}.png -resize 512x512 ${pname}_512.png
    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${executableName}.png

    substituteInPlace $out/share/applications/${executableName}.desktop \
      --replace 'Exec=AppRun' 'Exec=${executableName}'
  '';

  meta = {
    homepage = "https://www.mendeley.com";
    description = "Reference manager and academic social network";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ atila ];
    mainProgram = "mendeley-reference-manager";
  };

}
