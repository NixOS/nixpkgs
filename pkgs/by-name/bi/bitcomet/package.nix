{
  lib,
  appimageTools,
  fetchurl,
  webkitgtk_4_1,
}:

let
  pname = "bitcomet";
  version = "2.13.1";

  src = fetchurl {
    url = "https://download.bitcomet.com/linux/x86_64/BitComet-${version}-x86_64.AppImage";
    hash = "sha256-s8kCsPKr5XoS/Y6KzuiQV9ARq2UIo2PPKRinvik0aRo=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      libxml2
      libpng
      webkitgtk_4_1
    ];

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/com.bitcomet.linux.desktop $out/share/applications/bitcomet.desktop
    substituteInPlace $out/share/applications/bitcomet.desktop \
      --replace-fail 'Exec=usr/bin/BitComet' 'Exec=bitcomet'
    cp -r ${appimageContents}/usr/share/icons $out/share/icons
  '';

  meta = {
    homepage = "https://www.bitcomet.com";
    description = "Free BitTorrent download client";
    mainProgram = "bitcomet";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ];
  };
}
