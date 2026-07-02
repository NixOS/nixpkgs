{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
let
  pname = "archon-lite";
  version = "9.3.85";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/download/v${version}/archon-lite-v${version}.AppImage";
    hash = "sha256-ooNvgbtV6HKgzRLgHZul92NLnEB8oX6fHL6iwfHajVA=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application for uploading MMORPG combat logs";
    homepage = "https://www.archon.gg/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/tag/v${version}";
    license = lib.licenses.unfree; # no license listed
    mainProgram = "archon-lite";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hekazu
      sophiebsw
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
