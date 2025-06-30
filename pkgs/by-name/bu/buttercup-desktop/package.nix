{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "buttercup-desktop";
  version = "2.28.1";
  src = fetchurl {
    url = "https://github.com/buttercup/buttercup-desktop/releases/download/v${version}/Buttercup-linux-x86_64.AppImage";
    sha256 = "sha256-iCuvs+FisYPvCmPVg1dhYMX+Lw3WmrMSRytdy6TLrxg=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

in
appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/buttercup.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/buttercup.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cross-Platform Passwords & Secrets Vault";
    mainProgram = "buttercup-desktop";
    homepage = "https://buttercup.pw";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
