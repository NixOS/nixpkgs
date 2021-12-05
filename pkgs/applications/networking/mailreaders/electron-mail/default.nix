{ appimageTools, lib, fetchurl, libsecret }:

let
  pname = "electron-mail";
  version = "4.12.7";
  name = "ElectronMail-${version}";

  src = fetchurl {
    url =
      "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-linux-x86_64.AppImage";
    sha256 = "42d0b49a2feba628f4845940ffd9607739bd5fcdbe6ba37e15f993c511d21e46";
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

  extraPkgs = pkgs: with pkgs; [ libsecret ];

  meta = with lib; {
    description =
      "ElectronMail is an Electron-based unofficial desktop client for ProtonMail";
    homepage = "https://github.com/vladimiry/ElectronMail";
    license = licenses.mit;
    maintainers = [ maintainers.princemachiavelli ];
    platforms = [ "x86_64-linux" ];
  };
}
