{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "archon-lite";
  version = "9.3.66";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/download/v${version}/archon-lite-v${version}.AppImage";
    hash = "sha256-ZIonMhnX574Ykv3/7jX7MUfHi05sdsos0AhE8Cyw0Ao=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Application for uploading MMORPG combat logs";
    homepage = "https://www.archon.gg/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/latest";
    license = lib.licenses.unfree; # no license listed
    mainProgram = "archon-lite";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hekazu ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
