{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "0.12.8";
  pname = "Exiled-Exchange-2";

  src = fetchurl {
    url = "https://github.com/Kvan7/Exiled-Exchange-2/releases/download/v${version}/Exiled-Exchange-2-${version}.AppImage";
    hash = "sha256-hGUmwyhFsM+8XTrFCuaLVYAA85jwrKCftkQ/wlViRHI=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraInstallCommands = ''
    # Copy any extracted hicolor icons from the AppImage extraction output for the desktop file
    if [ -d "${appimageContents}/usr/share/icons/hicolor" ]; then
      find "${appimageContents}/usr/share/icons/hicolor" -type f -name "exiled-exchange-2.png" | while read -r f; do
        rel=$(printf '%s' "$f" | sed -e "s|^${appimageContents}/usr/share/icons/hicolor/||")
        dir=$(dirname "$rel")
        mkdir -p "$out/share/icons/hicolor/$dir"
        install -m 644 "$f" "$out/share/icons/hicolor/$rel"
      done
    fi

    mkdir -p "$out/share/applications"

    printf "%s\n" \
      "[Desktop Entry]" \
      "Type=Application" \
      "Name=Exiled Exchange 2" \
      "Exec=${pname}" \
      "Icon=exiled-exchange-2" \
      "Categories=Game;" \
      > "$out/share/applications/${pname}.desktop"
  '';

  meta = {
    description = "Companion app for the game Path of Exile 2 for trade price checking";
    homepage = "https://kvan7.github.io/Exiled-Exchange-2/quick-start";
    downloadPage = "https://github.com/Kvan7/Exiled-Exchange-2/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ chrisheib ];
    platforms = [ "x86_64-linux" ];
  };
}
