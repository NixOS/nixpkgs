{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "hiddify-next";
  version = "1.1.1";
  src = fetchurl {
    url = "https://github.com/hiddify/hiddify-next/releases/download/v${version}/Hiddify-Linux-x64.AppImage";
    hash = "sha256-T4BWxhJ7q13KE1rvvFsnXhs2XVEmNkFTJbJ4e8PCg+0=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ libepoxy ];
  extraInstallCommands = ''
    mv $out/bin/hiddify-next $out/bin/hiddify
    install -Dm644 ${appimageContents}/hiddify.desktop $out/share/applications/hiddify.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/hiddify.desktop \
      --replace-quiet 'LD_LIBRARY_PATH=usr/lib ' ''''''
  '';

  meta = with lib; {
    description = "Multi-platform auto-proxy client (appimage version)";
    longDescription = ''
      Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc.
    '';
    homepage = "https://github.com/hiddify/hiddify-next";
    license = licenses.cc-by-nc-sa-40;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ wenjinnn ];
    mainProgram = "hiddify";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
