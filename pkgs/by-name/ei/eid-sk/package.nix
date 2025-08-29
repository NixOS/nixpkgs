{
  lib,
  appimageTools,
  fetchzip,
}:

let
  pname = "eid-sk";
  version = "5.0";

  src = fetchzip {
    url = "https://eidas.minv.sk/downloadservice/eidklient/linux/eID_klient_x86_64.tar.gz";
    hash = "sha256-NQC0ZhlX2VzRZ2KkFOAIBdThgOlGSbgBAfRaXmEw2Lk=";
    stripRoot = false;
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = "${src}/eID_klient-x86_64.AppImage";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = "${src}/eID_klient-x86_64.AppImage";

  extraPkgs = pkgs: [ pkgs.pcsclite ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/eid-klient-mw.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/sk_logo.svg $out/share/icons/hicolor/512x512/apps/sk_logo.svg
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "Exec=AppRun --no-sandbox %U" "Exec=$out/bin/eID_Client"
  '';

  meta = with lib; {
    description = "eID client application (Slovak)";
    longDescription = ''
      Allows user authentication and digital signatures with Slovak ID cards.

      Also requires a running pcscd service and compatible card reader:

          services.pcscd.enable = true;

      To use eIDs in Firefox in NixOS use follwing configuration:

          programs.firefox.enable = true;
          programs.firefox.nativeMessagingHosts.euwebid = true;
    '';
    homepage = "https://www.slovensko.sk";
    license = licenses.unfree;
    maintainers = with maintainers; [ ktor ];
    platforms = [ "x86_64-linux" ];
  };
}
