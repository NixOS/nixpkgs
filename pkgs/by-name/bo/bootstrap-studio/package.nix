{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "bootstrap-studio";
  version = "8.0.1";
  src = fetchurl {
    url = "https://releases.bootstrapstudio.io/${version}/Bootstrap%20Studio.AppImage";
    sha256 = "sha256-uVeD6g3A9ITKkBp3AxTPUM3nyhCbW79gPVTU7bIDmhs=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/bstudio.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/bstudio.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/bstudio.png \
      $out/share/icons/hicolor/512x512/apps/bstudio.png
  '';

  meta = {
    description = "Drag-and-drop designer for bootstrap";
    homepage = "https://bootstrapstudio.io/";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
