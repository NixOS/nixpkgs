{ lib, fetchurl, appimageTools, imagemagick }:

let
  pname = "ledger-live-desktop";
  version = "2.51.0";

  src = fetchurl {
    url = "https://download.live.ledger.com/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-qpgzGJsj7hrrK2i+xP0T+hcw7WMlGBILbHVJBHD5duo=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/ledger-live-desktop.desktop $out/share/applications/ledger-live-desktop.desktop
    install -m 444 -D ${appimageContents}/ledger-live-desktop.png $out/share/icons/hicolor/1024x1024/apps/ledger-live-desktop.png
    ${imagemagick}/bin/convert ${appimageContents}/ledger-live-desktop.png -resize 512x512 ledger-live-desktop_512.png
    install -m 444 -D ledger-live-desktop_512.png $out/share/icons/hicolor/512x512/apps/ledger-live-desktop.png
    substituteInPlace $out/share/applications/ledger-live-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Wallet app for Ledger Nano S and Ledger Blue";
    homepage = "https://www.ledger.com/live";
    license = licenses.mit;
    maintainers = with maintainers; [ andresilva thedavidmeister nyanloutre RaghavSood th0rgal WeebSorceress ];
    platforms = [ "x86_64-linux" ];
  };
}
