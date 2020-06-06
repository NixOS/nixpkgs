{ lib, fetchurl, appimageTools }:

let
  pname = "deltachat-electron";
  version = "1.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url =
      "https://download.delta.chat/desktop/v${version}/DeltaChat-${version}.AppImage";
    sha256 = "1xyp8cg11px8rras12sncjmq85alyvz7ycw1v1py8w8rlz60wkij";
  };

  appimageContents = appimageTools.extract { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D \
      ${appimageContents}/deltachat-desktop.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Electron client for DeltaChat";
    homepage = "https://delta.chat/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ehmry ];
    platforms = [ "x86_64-linux" ];
  };
}
