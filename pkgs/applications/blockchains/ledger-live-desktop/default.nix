{ lib, fetchurl, appimageTools, imagemagick }:

let
  pname = "ledger-live-desktop";
<<<<<<< HEAD
  version = "2.66.0";

  src = fetchurl {
    url = "https://download.live.ledger.com/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-Du2bvtlNjxtkJ31RCKZmGtWxOEIjohbmEC5o3VvFGlY=";
  };


=======
  version = "2.57.0";

  src = fetchurl {
    url = "https://download.live.ledger.com/${pname}-${version}-linux-x86_64.AppImage";
    hash = "sha256-fXvCj9eBEp/kGPSiNUdir19eU0x461KzXgl5YgeapHI=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    description = "App for Ledger hardware wallets";
    homepage = "https://www.ledger.com/ledger-live/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ andresilva thedavidmeister nyanloutre RaghavSood th0rgal ];
=======
    maintainers = with maintainers; [ andresilva thedavidmeister nyanloutre RaghavSood th0rgal WeebSorceress ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
  };
}
