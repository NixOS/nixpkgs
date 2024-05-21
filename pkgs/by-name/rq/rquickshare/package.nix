{ stdenvNoCC, appimageTools, fetchurl, lib, makeDesktopItem, copyDesktopItems }:

let
  app = let
    version = "0.7.1";
  in
    appimageTools.wrapType2 {
      name = "rquickshare";
      src = fetchurl {
        url = "https://github.com/Martichou/rquickshare/releases/download/v${version}/r-quick-share_${version}_amd64.AppImage";
        hash = "sha256-716d7T4nbs/dDS4KVGTADCpLO31U8iq6hDVD+c7Ks1I=";
      };
    };
  icon = fetchurl {
    url = "https://github.com/Martichou/rquickshare/blob/3ae1396f05cd9e97e3775adc46b9c2b204ff2104/snap/gui/r-quick-share.png";
    hash = "sha256-fbx1oJIiTUDMzI3RdqvW+dH85fUjI1o94hor+yiDNW4=";
  };
in
  stdenvNoCC.mkDerivation {
    name = "rquickshare";
    src = app;
    nativeBuildInputs = [ copyDesktopItems ];
    installPhase = ''
      mkdir -p $out/bin
      cp -r $src/bin/rquickshare $out/bin/rquickshare

      runHook postInstall
    '';
    desktopItems = [
      (makeDesktopItem {
        name = "rQuickShare";
        desktopName = "rQuickShare";
        exec = "rquickshare";
        icon = icon;
        type = "Application";
        terminal = false;
        categories = [ "Development" ];
      })
    ];
    meta = with lib; {
      description = "A Quickshare client in Rust";
      homepage = "https://github.com/Martichou/rquickshare";
      changelog = "https://github.com/Martichou/rquickshare/blob/master/CHANGELOG.md";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ hannesgith ];
      mainProgram = "rquickshare";
      platforms = [ "x86_64-linux" ];
    };
  }
