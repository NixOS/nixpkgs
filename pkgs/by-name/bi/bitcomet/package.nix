{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "bitcomet";
  version = "2.13.2";

  src = fetchurl {
    url = "https://download.bitcomet.com/linux/x86_64/BitComet-${version}-x86_64.AppImage";
    hash = "sha256-T66hmWmjt7ZZj03IxTSYtNUBoFHgwOoAIOHMyJSAmbU=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      libxml2
      libpng
      webkitgtk_4_0
    ];

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/com.bitcomet.linux.desktop $out/share/applications/bitcomet.desktop
    substituteInPlace $out/share/applications/bitcomet.desktop \
      --replace-fail "Exec=usr/bin/BitComet" "Exec=bitcomet"
    cp -r ${appimageContents}/usr/share/icons $out/share/icons
  '';

  meta = {
    homepage = "https://www.bitcomet.com";
    description = "BitTorrent download client";
    mainProgram = "bitcomet";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ];
  };
}
