{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "electronplayer";
  version = "2.0.8";

  #TODO: remove the -rc4 from the tag in the url when possible
  src = fetchurl {
    url = "https://github.com/oscartbeaumont/ElectronPlayer/releases/download/v${version}-rc4/${pname}-${version}.AppImage";
    sha256 = "wAsmSFdbRPnYnDyWQSbtyj+GLJLN7ibksUE7cegfkhI=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=ElectronPlayer'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Electron based web video services player";
    mainProgram = "electronplayer";
    homepage = "https://github.com/oscartbeaumont/ElectronPlayer";
    license = licenses.mit;
    maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
