{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:
let
  pname = "filen-desktop";
  version = "3.0.47";

  arch = builtins.head (builtins.split "-" stdenv.hostPlatform.system);

  src = fetchurl {
    url = "https://github.com/FilenCloudDienste/filen-desktop/releases/download/v${version}/Filen_linux_${arch}.AppImage";
    hash = "sha256-keaD5PUjkoFrFTCuap4DvmYq5X3Tjnq+njtiLgAZ9W8=";
  };

  desktopItem = makeDesktopItem {
    name = "filen-desktop";
    desktopName = "Filen Desktop";
    comment = "Encrypted Cloud Storage";
    icon = "filen-desktop";
    exec = "filen-desktop %u";
    categories = [ "Office" ];
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications ${appimageContents}/usr/share/icons
    chmod -R +w $out/share
    find $out/share/icons -type f -iname "*.png" -execdir mv {} "$pname.png" \;
  '';

  meta = {
    homepage = "https://filen.io/products/desktop";
    downloadPage = "https://github.com/FilenCloudDienste/filen-desktop/releases/";
    description = "Filen Desktop Client for Linux";
    longDescription = ''
      Encrypted Cloud Storage built for your Desktop.
      Sync your data, mount network drives, collaborate with others and access files natively — powered by robust encryption and seamless integration.
    '';
    mainProgram = "filen-desktop";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ smissingham ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
