{
  fetchurl,
  appimageTools,
  makeWrapper,
  imagemagick,
  lib,
}:
let
  pname = "capacities";
  version = "1.52.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://web.archive.org/web/20250519011655/https://capacities-desktop-app.fra1.cdn.digitaloceanspaces.com/capacities-${version}.AppImage";
    hash = "sha256-M5K2TxrB2Ut/wYKasl8EqbzLjFJrqjWfPIJTZV4fi4s=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit
      pname
      src
      version
      ;
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    src
    version
    ;

  extraInstallCommands = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/capacities \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    # Check for required desktop file
    if [ ! -f ${appimageContents}/capacities.desktop ]; then
      echo "Error: Missing .desktop file in ${appimageContents}"
      exit 1
    else
      # Install and modify the desktop file
      install -m 444 -D ${appimageContents}/capacities.desktop $out/share/applications/capacities.desktop
    fi

    # Check for required icon file
    if [ ! -f ${appimageContents}/capacities.png ]; then
      echo "Error: Missing icon file in ${appimageContents}"
      exit 1
    else
      # Resize and install the icon
      ${lib.getExe imagemagick} ${appimageContents}/capacities.png -resize 512x512 capacities_512.png
      install -m 444 -D capacities_512.png $out/share/icons/hicolor/512x512/apps/capacities.png
    fi
  '';

  meta = {
    description = "Calm place to make sense of the world and create amazing things";
    homepage = "https://capacities.io/";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "capacities";
  };
}
