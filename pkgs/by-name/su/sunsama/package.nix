{
  appimageTools,
  lib,
  fetchurl,
}:

let
  version = "3.1.1";
  pname = "sunsama";
  src = fetchurl {
    url = "https://download.todesktop.com/2003096gmmnl0g1/sunsama-${version}-build-250512vfxlcgvds-x86_64.AppImage";
    sha512 = "VOzD/kWfsP2GR1uYkVUdjAuw9tlKjHRNxYuDSYYH7fn43Bk+wfgom/ofu3it/vQjjtuezkTN6gi96U87ypQrSA==";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png $out/share/pixmaps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "The digital daily planner that helps you feel calm and stay focused.";
    homepage = "https://sunsama.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ dan-kc ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sunsama";
  };
}
