{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "mapillary-desktop-uploader";
  version = "5.0.3";

  src = fetchurl {
    url = "https://tools.mapillary.com/uploader/download/mapillary-uploader-${version}.AppImage";
    hash = "sha256-hpWdfeuhYylO+SFD3BsKI0s/xtObCDd5OcuJ6i/aEuI=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-warn 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U' \
      --replace-warn 'Exec=AppRun' 'Exec=${pname}'

    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Upload imagery to the Mapillary platform";
    longDescription = "Upload large amounts of street-level imagery directly from the comfort of your desktop.";
    homepage = "https://www.mapillary.com/desktop-uploader";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ StrangeGirlMurph ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mapillary-desktop-uploader";
  };
}
