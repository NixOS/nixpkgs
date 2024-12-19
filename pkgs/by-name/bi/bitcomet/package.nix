{
  lib,
  fetchurl,
  appimageTools,
  webkitgtk_4_0,
}:
let
  pname = "bitcomet";
  version = "2.12.0";
  src = fetchurl {
    url = "https://download.bitcomet.com/linux/x86_64/BitComet-${version}-x86_64.AppImage";
    hash = "sha256-TbEdormqEZJymOQF8ftpZ6JBU1AeCdkQ/FAzRYrgaJ4=";
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
    mkdir -p $out/share/applications
    install -m 444 ${appimageContents}/com.bitcomet.linux.desktop $out/share/applications/bitcomet.desktop
    substituteInPlace $out/share/applications/bitcomet.desktop \
      --replace-fail 'Exec=usr/bin/BitComet' 'Exec=bitcomet'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    homepage = "https://www.bitcomet.com";
    description = "Free BitTorrent download client";
    mainProgram = "bitcomet";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ aucub ];
  };
}
