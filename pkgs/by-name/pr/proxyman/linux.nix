{
  appimageTools,
  fetchurl,
  asar,
  pname,
  updateScript,
  meta,
}:
let
  version = "3.16.1";

  src = fetchurl {
    url = "https://github.com/ProxymanApp/proxyman-windows-linux/releases/download/${version}/Proxyman-${version}.AppImage";
    hash = "sha256-rykOZVrh3MATFDzwLS7gEj5sMD9udsWAi+68Quqzk0c=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      ${asar}/bin/asar extract $out/resources/app.asar app

      # This will fix the issue with Proxyman not detecting NixOS as a valid Linux environment
      substituteInPlace app/dist/main/main.js \
        --replace-fail 'systemTrustFilename:"/etc/ca-certificates/trust-source/anchors/%s.crt",trustCommands:["update-ca-trust extract"]' 'systemTrustFilename:"/etc/ssl/certs/%s.crt",trustCommands:[]' \
        --replace-fail '{path:"/etc/ca-certificates/trust-source/anchors/",distroFamily:"arch"}' '{path:"/etc/ssl/certs/",distroFamily:"arch"}'

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
    install -Dm444 ${appimageContents}/proxyman.png -t $out/share/icons/hicolor/256x256/apps
    substituteInPlace $out/share/applications/proxyman.desktop \
      --replace-fail "Exec=AppRun" "Exec=proxyman --"
  '';

  passthru = {
    inherit updateScript;
    inherit src;
  };

  meta = meta // {
    changelog = "https://proxyman.com/changelog-windows";
    platforms = [ "x86_64-linux" ];
  };
}
