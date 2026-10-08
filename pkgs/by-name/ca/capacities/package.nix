{
  fetchurl,
  appimageTools,
  makeWrapper,
  imagemagick,
  lib,
}:
let
  inherit (lib.importJSON ./version.json) version url sha256;

  pname = "capacities";

  src = fetchurl { inherit url sha256; };

  appimageContents = appimageTools.extract {
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
      --add-flags "--ozone-platform-hint=auto"

    # Check for required desktop file
    if [ ! -f ${appimageContents}/io.capacities.app.desktop ]; then
      echo "Error: Missing .desktop file in ${appimageContents}"
      exit 1
    else
      # Install and modify the desktop file
      install -m 444 -D ${appimageContents}/io.capacities.app.desktop $out/share/applications/io.capacities.app.desktop
      substituteInPlace $out/share/applications/io.capacities.app.desktop \
        --replace-fail "Exec=AppRun" "Exec=capacities"
    fi

    # Check for required icon file
    if [ ! -f ${appimageContents}/capacities.svg ]; then
      echo "Error: Missing icon file in ${appimageContents}"
      exit 1
    else
      # Resize and install the icon
      ${lib.getExe imagemagick} ${appimageContents}/capacities.svg -resize 512x512 capacities_512.png
      install -m 444 -D capacities_512.png $out/share/icons/hicolor/512x512/apps/capacities.png
    fi
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Calm place to make sense of the world and create amazing things";
    homepage = "https://capacities.io/";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "capacities";
    maintainers = [ lib.maintainers.keysmashes ];
  };
}
