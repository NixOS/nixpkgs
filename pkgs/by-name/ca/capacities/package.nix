{
  fetchurl,
  appimageTools,
  makeWrapper,
  imagemagick,
  lib,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "capacities";
  version = "1.65.13";

  src = fetchurl {
    url = "https://web.archive.org/web/20260518194627/https://2vks4.upcloudobjects.com/capacities-desktop-app/Capacities-1.65.13.AppImage";
    hash = "sha256-ATiX1h9hXmKMFtY6OEyZEoJ/SxJGgbj5/QZwFF1sfFQ=";
  };

  extraInstallCommands = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/capacities \
      --add-flags "--ozone-platform-hint=auto"

    # Check for required desktop file
    if [ ! -f ${finalAttrs.contents}/capacities.desktop ]; then
      echo "Error: Missing .desktop file in ${finalAttrs.contents}"
      exit 1
    else
      # Install and modify the desktop file
      install -m 444 -D ${finalAttrs.contents}/capacities.desktop $out/share/applications/capacities.desktop
      substituteInPlace $out/share/applications/capacities.desktop \
        --replace-fail "Exec=AppRun" "Exec=capacities"
    fi

    # Check for required icon file
    if [ ! -f ${finalAttrs.contents}/capacities.png ]; then
      echo "Error: Missing icon file in ${finalAttrs.contents}"
      exit 1
    else
      # Resize and install the icon
      ${lib.getExe imagemagick} ${finalAttrs.contents}/capacities.png -resize 512x512 capacities_512.png
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
    maintainers = [ lib.maintainers.keysmashes ];
  };
})
