{ lib
, fetchurl
, appimageTools
}:

let
  pname = "cozydrive";
<<<<<<< HEAD
  version = "3.38.0";
=======
  version = "3.32.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/cozy-labs/cozy-desktop/releases/download/v${version}/Cozy-Drive-${version}-x86_64.AppImage";
<<<<<<< HEAD
    sha256 = "3liOzZVOjtV1cGrKlOKiFRRqnt8KHPr5Ye5HU0e/BYo=";
=======
    sha256 = "0qd5abswqbzqkk1krn9la5d8wkwfydkqrnbak3xmzbdxnkg4gc9a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  appimageContents = appimageTools.extract { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/cozydrive.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/cozydrive.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cozy Drive is a synchronization tool for your files and folders with Cozy Cloud.";
    homepage = "https://cozy.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ simarra ];
    platforms = [ "x86_64-linux" ];
  };
}
