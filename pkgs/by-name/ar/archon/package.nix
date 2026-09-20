{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:

let
  pname = "archon";
  version = "9.6.43";

  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-archon/releases/download/v${version}/archon-v${version}.AppImage";
    hash = "sha256-hpSuaz6+akvN4QzyHth2eW/6PHgcDjBKJDnIbZGg8HQ=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/archon.desktop $out/share/applications/archon.desktop
    substituteInPlace $out/share/applications/archon.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=archon --no-sandbox %U'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/archon.png $out/share/icons/hicolor/512x512/apps/archon.png
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(.*)$"
    ];
  };

  meta = {
    description = "Archon Desktop App for World of Warcraft";
    homepage = "https://www.archon.gg";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ thebigjc ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "archon";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
