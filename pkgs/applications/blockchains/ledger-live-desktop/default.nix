{ lib, fetchurl, appimageTools, imagemagick }:

let
  pname = "ledger-live-desktop";
  version = "2.31.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/LedgerHQ/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    sha256 = "0cxf4i58l0kg9c13j7mf0w5ijrkkf9z1375vn6xghd0r8g5hvws5";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
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
    maintainers = with maintainers; [ andresilva thedavidmeister nyanloutre RaghavSood th0rgal ];
    platforms = [ "x86_64-linux" ];
  };
}
