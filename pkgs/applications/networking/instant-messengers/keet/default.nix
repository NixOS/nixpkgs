{ lib, appimageTools, fetchurl }:

let
  pname = "keet";
  version = "1.2.1";

  src = fetchurl {
    url = "https://keet.io/downloads/${version}/Keet.AppImage";
    sha256 = "1f76ccfa16719a24f6d84b88e5ca49fab1c372de309ce74393461903c5c49d98";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit src pname version;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Peer-to-Peer Chat";
    homepage = "https://keet.io";
    license = licenses.unfree;
    maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
