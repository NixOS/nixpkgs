{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:
let
  pname = "bitcomet";
  version = "2.9.0";
  src = fetchurl {
    url = "https://download.bitcomet.com/linux/x86_64/BitComet-${version}-x86_64.AppImage";
    sha256 = "ZRhpn78D65m3fQb9Uj2KEZ8ATqB+NU7C9f+xS6uZqWk=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      libxml2
      libpng
      webkitgtk
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
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
    maintainers = with lib.maintainers; [ aucub ];
  };
}
