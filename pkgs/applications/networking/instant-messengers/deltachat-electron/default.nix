{ lib, fetchurl, appimageTools, gsettings-desktop-schemas, gtk3 }:

let
  pname = "deltachat-electron";
  version = "1.20.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://download.delta.chat/desktop/v${version}/DeltaChat-${version}.AppImage";
    sha256 = "sha256-u0YjaXb+6BOBWaZANPcaxp7maqlBWAtecSsCGbr67dk=";
  };

  appimageContents = appimageTools.extract { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

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
