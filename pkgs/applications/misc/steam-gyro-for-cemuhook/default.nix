{ lib
, fetchurl
, appimageTools
}:

let
  pname = "steam-gyro-for-cemuhook";
  version = "1.4.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/FrogTheFrog/steam-gyro-for-cemuhook/releases/download/${version}/steam-gyro-for-cemuhook-${version}.AppImage";
    sha256 = "sha256-OjuJUDeuKm4qTkv9MpLV6Az7SpQjYwliKLsTsbgD9lg=";
  };
  appimageContents = appimageTools.extract { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/steam-gyro-for-cemuhook.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/steam-gyro-for-cemuhook.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "An application that enables Gyro controls for various emulators with the Steam Controller";
    homepage = "https://github.com/FrogTheFrog/steam-gyro-for-cemuhook";
    license = licenses.mit;
    maintainers = with maintainers; [ krutonium ];
    platforms = [ "x86_64-linux" ];
  };
}
