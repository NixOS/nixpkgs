{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  directoryListingUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bbedit";
  version = "16.1.1";

  src = fetchurl {
    url = "https://s3.amazonaws.com/BBSW-download/BBEdit_${finalAttrs.version}.dmg";
    hash = "sha256-rdiS2Bkdo6sTRRKj4ZnJDYLwf0ZeyemCzS9R8iWiqKg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  # app bundle may be messed up by standard fixup
  dontFixup = true;

  passthru.updateScript = directoryListingUpdater {
    # must match the DMG filename prefix (case-sensitive)
    pname = "BBEdit";
    url = "https://www.barebones.com/products/bbedit/download.html";
  };

  meta = {
    description = "Powerful and full-featured professional HTML and text editor for macOS";
    homepage = "https://www.barebones.com/products/bbedit/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
