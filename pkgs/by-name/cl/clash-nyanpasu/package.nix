{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
appimageTools.wrapType2 rec {
  pname = "clash-nyanpasu";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/LibNyanpasu/clash-nyanpasu/releases/download/v${version}/clash-nyanpasu_${version}_amd64.AppImage";
    hash = "sha256-buxhsO/X4orChaMYA2JgceeybWRlryPqY1PlF+9KoNI=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -Dm444 ${appimageContents}/clash-nyanpasu.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/keiko233/clash-nyanpasu";
    license = lib.licenses.gpl3Plus;
    mainProgram = "clash-nyanpasu";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
