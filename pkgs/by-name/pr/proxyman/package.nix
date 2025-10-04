{
  lib,
  appimageTools,
  fetchurl,
  asar,
}:
let
  pname = "proxyman";
  version = "3.2.0";

  src = fetchurl {
    url = "https://github.com/ProxymanApp/proxyman-windows-linux/releases/download/${version}/Proxyman-${version}.AppImage";
    hash = "sha256-u6Lu5blU1z7UJyiBZFj/dqKeoCfMniXz6ul2TQwaOqI=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      ${asar}/bin/asar extract $out/resources/app.asar app

      # This will fix the issue with Proxyman not detecting NixOS as a valid Linux environment
      substituteInPlace app/dist/main/main.js --replace-fail "/etc/ca-certificates/trust-source/anchors/" "/etc/ssl/certs/"

      # This will permanently mark the certificate as installed, as this should be done through Nix config rather than
      # placing / editing a file in /etc like Proxyman would expect.
      # Configure the certificate located in "~/.config/Proxyman/certificate/certs/ca.pem" using security.pki.certificates in your nix config
      substituteInPlace app/dist/main/main.js --replace-fail "return this.isFile(this.getNewCertPath(e))" "return true"

      ${asar}/bin/asar pack app $out/resources/app.asar
    '';
  };

in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/proxyman.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/proxyman.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/proxyman.desktop \
      --replace-fail "Exec=AppRun" "Exec=proxyman --"
  '';

  meta = {
    description = "Capture, inspect, and manipulate HTTP(s) requests/responses with ease";
    homepage = "https://proxyman.com";
    changelog = "https://proxyman.com/changelog-windows";
    license = lib.licenses.unfree;
    mainProgram = "proxyman";
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
