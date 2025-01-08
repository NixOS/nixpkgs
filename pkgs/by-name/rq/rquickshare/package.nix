{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "rquickshare";
  version = "0.11.3";
  src = fetchurl {
    url = "https://github.com/Martichou/rquickshare/releases/download/v${version}/r-quick-share-legacy_v${version}_glibc-2.31_amd64.AppImage";
    hash = "sha256-SEAm4K00bdVaLEEF17EapbxtfSGBE2Kv1eIQ2GHsHdM=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/r-quick-share.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/r-quick-share.desktop \
      --replace-fail 'Exec=r-quick-share' 'Exec=r-quick-share %u'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Rust implementation of NearbyShare/QuickShare from Android for Linux";
    homepage = "https://github.com/Martichou/rquickshare";
    changelog = "https://github.com/Martichou/rquickshare/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "rquickshare";
  };
}
