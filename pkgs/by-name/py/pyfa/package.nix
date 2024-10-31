{
  lib,
  appimageTools,
  fetchurl,
}:
let
  version = "2.60.1";
in
appimageTools.wrapType2 {
  inherit version;
  pname = "pyfa";

  src = fetchurl {
    name = "pyfa-appimage-${version}";
    url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/pyfa-v${version}-linux.AppImage";
    hash = "sha256-+nyIG6pweIgC6ZiWJaO4E2Fp0/zP+DhQrUWzHnIBQXk=";
  };

  meta = {
    description = "Python fitting assistant, cross-platform fitting tool for EVE Online";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      toasteruwu
      cholli
    ];
    mainProgram = "pyfa";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.linux;
  };
}
