{ appimageTools, lib, fetchurl }:

let
  pname = "molotov";
  version = "4.2.2";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://desktop-auto-upgrade.molotov.tv/linux/${version}/molotov.AppImage";
    sha256 = "00p8srf4yswbihlsi3s7kfkav02h902yvrq99wys11is63n01x8z";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D \
      ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
  meta = with lib; {
    description = "French TV service";
    homepage = "https://www.molotov.tv/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ apeyroux freezeboy ];
    platforms = [ "x86_64-linux" ];
  };
}
