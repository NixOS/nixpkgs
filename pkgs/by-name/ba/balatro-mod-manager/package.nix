{
  lib,
  appimageTools,
  fetchurl,
  ...
}:

let
  version = "0.3.8";
  pname = "balatro-mod-manager";

  src = fetchurl {
    url = "https://github.com/skyline69/balatro-mod-manager/releases/download/v${version}/Balatro.Mod.Manager_${version}_amd64.AppImage";
    hash = "sha256-O03A4ErrJD31Ltn3BIQVBRb458dtj/zeORqln/gCd40=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    # install desktop file
    install -m 444 -D "${appimageContents}/Balatro Mod Manager.desktop" "$out/share/applications/${pname}.desktop"

    # install icons
    if [ -d "${appimageContents}/usr/share/icons" ]; then
      mkdir -p "$out/share/icons"
      cp -r "${appimageContents}/usr/share/icons"/* "$out/share/icons/"
    fi

    # patch Exec line
    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace-fail 'Exec=BMM' 'Exec=${meta.mainProgram}'
  '';

  meta = {
    mainProgram = "balatro-mod-manager";
    description = "Mod manager for Balatro";
    homepage = "https://github.com/skyline69/balatro-mod-manager";
    downloadPage = "https://github.com/skyline69/balatro-mod-manager/releases";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ drxxmy ];
    platforms = [ "x86_64-linux" ];
  };
}
