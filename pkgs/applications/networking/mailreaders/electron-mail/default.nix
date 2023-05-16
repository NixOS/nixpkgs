{ appimageTools, lib, fetchurl, libsecret }:

let
  pname = "electron-mail";
<<<<<<< HEAD
  version = "5.1.8";
=======
  version = "5.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  name = "ElectronMail-${version}";

  src = fetchurl {
    url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-linux-x86_64.AppImage";
<<<<<<< HEAD
    sha256 = "sha256-btqlxFrQUyb728i99IE65A9jwEFNvJ5b6zji0kwwATU=";
=======
    sha256 = "sha256-lsXVsx7U43czWFWxAgwTUYTnUXSL4KPFnXLzUklieAo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs = pkgs: with pkgs; [
    libsecret
    libappindicator-gtk3
  ];

  meta = with lib; {
    description = "ElectronMail is an Electron-based unofficial desktop client for ProtonMail";
    homepage = "https://github.com/vladimiry/ElectronMail";
    license = licenses.gpl3;
    maintainers = [ maintainers.princemachiavelli ];
    platforms = [ "x86_64-linux" ];
  };
}
