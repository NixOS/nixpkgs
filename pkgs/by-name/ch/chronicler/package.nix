{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  webkitgtk_4_1, # matches the .deb dependency libwebkit2gtk-4.1-0
  wrapGAppsHook3, # ensures GTK environment variables are set
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chronicler";
  version = "0.47.0";

  src = fetchurl {
    url = "https://github.com/mak-kirkland/chronicler/releases/download/v${finalAttrs.version}-alpha/Chronicler_${finalAttrs.version}_amd64.deb";
    hash = "sha256-+HEdiyoPaFrvHS9rndTUMTSHN2QRS1/bVFMNfcTD/4I=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];

  installPhase = ''
    runHook preInstall

    dpkg -x $src $out

    # Move files from usr/ to the root of $out
    cp -r $out/usr/* $out/
    rm -rf $out/usr

    # Some .deb packages also install to /opt; handle that if present
    if [ -d $out/opt ]; then
      cp -r $out/opt/* $out/
      rm -rf $out/opt
    fi

    # Ensure binaries are executable
    find $out/bin $out/lib -type f -exec chmod +x {} \; 2>/dev/null || true

    runHook postInstall
  '';

  # autoPatchelfHook and wrapGAppsHook automatically fix binaries and set up GTK.

  meta = {
    description = "Worldbuilding application to manage complex fictional worlds";
    longDescription = ''
      Chronicler is an application for worldbuilding, allowing you to create
      and manage complex fictional worlds.
    '';
    homepage = "https://chronicler.pro/";
    license = lib.licenses.polyFormShield;
    maintainers = with lib.maintainers; [ enderfare ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
