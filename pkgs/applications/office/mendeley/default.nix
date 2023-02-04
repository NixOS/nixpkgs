{ lib
, fetchurl
, appimageTools
, gconf
, imagemagick
}:

let
  name = "mendeley";
  version = "2.80.1";

  executableName = "${name}-reference-manager";

  src = fetchurl {
    url = "https://static.mendeley.com/bin/desktop/mendeley-reference-manager-2.80.1-x86_64.AppImage";
    sha256 = "sha256-uqmu7Yf4tXDlNGkeEZut4m339S6ZNKhAmej+epKLB/8=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${executableName}
    install -m 444 -D ${appimageContents}/${executableName}.desktop $out/share/applications/${executableName}.desktop
    ${imagemagick}/bin/convert ${appimageContents}/${executableName}.png -resize 512x512 ${name}_512.png
    install -m 444 -D ${name}_512.png $out/share/icons/hicolor/512x512/apps/${executableName}.png

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
