{ appimageTools, lib, fetchurl }:
let
  pname = "electronplayer";
  version = "2.0.8";
  name = "${pname}-${version}";

  #TODO: remove the -rc4 from the tag in the url when possible
  src = fetchurl {
    url = "https://github.com/oscartbeaumont/ElectronPlayer/releases/download/v${version}-rc4/${name}.AppImage";
    sha256 = "wAsmSFdbRPnYnDyWQSbtyj+GLJLN7ibksUE7cegfkhI=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=ElectronPlayer'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "An electron based web video services player";
    homepage = "https://github.com/oscartbeaumont/ElectronPlayer";
    license = licenses.mit;
    maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
