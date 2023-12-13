{ lib
, fetchurl
, appimageTools
, gconf
, imagemagick
}:

let
  pname = "mendeley";
  version = "2.105.0";

  executableName = "${pname}-reference-manager";

  src = fetchurl {
    url = "https://static.mendeley.com/bin/desktop/mendeley-reference-manager-${version}-x86_64.AppImage";
    hash = "sha256-vs430WLApRu+Xw2gYgriOD0jsQqTW+qhI1g4r67W9aM=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/$name $out/bin/${executableName}
    install -m 444 -D ${appimageContents}/${executableName}.desktop $out/share/applications/${executableName}.desktop
    ${imagemagick}/bin/convert ${appimageContents}/${executableName}.png -resize 512x512 ${pname}_512.png
    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${executableName}.png

    substituteInPlace $out/share/applications/${executableName}.desktop \
      --replace 'Exec=AppRun' 'Exec=${executableName}'
  '';

  meta = with lib; {
    homepage = "https://www.mendeley.com";
    description = "A reference manager and academic social network";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers  = with maintainers; [ dtzWill atila ];
  };

}
