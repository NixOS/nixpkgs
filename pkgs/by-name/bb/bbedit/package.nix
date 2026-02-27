{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bbedit";
  version = "15.5.5";

  src = fetchurl {
    url = "https://s3.amazonaws.com/BBSW-download/BBEdit_${finalAttrs.version}.dmg";
    hash = "sha256-DsrGj2id9XUf3n55s0OHoJnX4AQY5AqiP9skaXysghk=";
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

  meta = {
    description = "Powerful and full-featured professional HTML and text editor for macOS";
    homepage = "https://www.barebones.com/products/bbedit/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
