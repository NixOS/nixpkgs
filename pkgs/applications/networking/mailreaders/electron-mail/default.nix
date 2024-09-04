{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
}:

let
  pname = "electron-mail";
  version = "5.2.2";

  src = fetchurl {
    url = "https://github.com/vladimiry/ElectronMail/releases/download/v${version}/electron-mail-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-bGqTPP+djpr+RFS6X7jUlSbxl7UDUaZLWQ3D/R76zEI=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs = pkgs: [
    pkgs.libsecret
    pkgs.libappindicator-gtk3
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "ElectronMail is an Electron-based unofficial desktop client for ProtonMail";
    mainProgram = "electron-mail";
    homepage = "https://github.com/vladimiry/ElectronMail";
    license = licenses.gpl3;
    maintainers = [ maintainers.princemachiavelli ];
    platforms = [ "x86_64-linux" ];
    changelog = "https://github.com/vladimiry/ElectronMail/releases/tag/v${version}";
  };
}
