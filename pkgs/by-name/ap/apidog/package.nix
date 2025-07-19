{
  pkgs,
  fetchzip,
  appimageTools,
  makeWrapper,
  imagemagick,
  lib,
  ...
}:
let
  pname = "apidog";
  version = "2.6.30";
  name = "${pname}-${version}";

  zipFile = fetchzip {
    url = "https://web.archive.org/web/20241114142057if_/https://file-assets.apidog.com/download/Apidog-linux-latest.zip";
    sha256 = "sha256-tkGL4+Ol/9H92vemJIe5riyg+l6mGHWK5q5Mz6gK5no=";
    stripRoot = false;
  };

  # Extract AppImage to a new derivation
  src = pkgs.runCommand "apidog-appimage" { } ''
    cp ${zipFile}/Apidog.AppImage $out
    chmod +x $out
  '';

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 rec {
  inherit name;
  inherit src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --use-gl=desktop}}"

    # Check for required desktop file
    if [ ! -f ${appimageContents}/apidog.desktop ]; then
      echo "Error: Missing .desktop file in ${appimageContents}"
      exit 1
    else
      # Install and modify the desktop file
      install -m 444 -D ${appimageContents}/apidog.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=Apidog' 'Exec=${pname}'
    fi

    # Check for required icon file
    if [ ! -f ${appimageContents}/apidog.png ]; then
      echo "Error: Missing icon file in ${appimageContents}"
      exit 1
    else
      # Resize and install the icon
      ${imagemagick}/bin/magick ${appimageContents}/apidog.png -resize 512x512 ${pname}_512.png
      install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    fi
  '';

  meta = {
    description = "Platform for building, testing, and documenting APIs";
    homepage = "https://apidog.com/";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "apidog";
  };
}
