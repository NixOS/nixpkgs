{
  fetchurl,
  appimageTools,
  makeWrapper,
  imagemagick,
  lib,
  ...
}:
let
  pname = "capacities";
  version = "1.43.34";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://capacities-desktop-app.fra1.cdn.digitaloceanspaces.com/Capacities-1.43.34.AppImage";
    sha256 = "sha256-2XQOog60plA8yJX/y+89Us0fTGB2BPiKnLyCS2AjrXI=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    # Check for required desktop file
    if [ ! -f ${appimageContents}/capacities.desktop ]; then
      echo "Error: Missing .desktop file in ${appimageContents}"
      exit 1
    else
      # Install and modify the desktop file
      install -m 444 -D ${appimageContents}/capacities.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=capacities' 'Exec=${pname}'
    fi

    # Check for required icon file
    if [ ! -f ${appimageContents}/capacities.png ]; then
      echo "Error: Missing icon file in ${appimageContents}"
      exit 1
    else
      # Resize and install the icon
      ${imagemagick}/bin/magick ${appimageContents}/capacities.png -resize 512x512 ${pname}_512.png
      install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
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
