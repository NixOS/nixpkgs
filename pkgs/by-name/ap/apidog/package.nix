{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:

let
  pname = "apidog";
  version = "2.7.51";

  src = fetchurl {
    url = "https://file-assets.apidog.com/download/${version}/Apidog-${version}.AppImage";
    hash = "sha256-MEVnpzVRj0Mi+ZX9CVi5dyDlV3rxuSC5tYM03bqdw0Q=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "apidog %U";
    icon = "apidog";
    desktopName = "Apidog";
    comment = "All-in-One API Platform: Design, Debug, Mock, Test, and Document.";
    categories = [
      "Development"
      "Utility"
    ];
    mimeTypes = [ "x-scheme-handler/apidog" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      nss
      gtk3
      xorg.libX11
      xorg.libxcb
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXext
      libdbusmenu
      alsa-lib
      nodejs
    ];

  extraInstallCommands = ''

    install -Dm444 ${appimageContents}/apidog.png \
      $out/share/icons/hicolor/512x512/apps/apidog.png
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "All-in-one API design, test, mock and documentation platform";
    homepage = "https://apidog.com";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "apidog";
    maintainers = with maintainers; [ DomagojAlaber ];
  };
}
