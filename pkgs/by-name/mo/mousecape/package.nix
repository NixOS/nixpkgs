{ lib
, stdenvNoCC
, fetchzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mousecape";
  version = "1813";

  src = fetchzip {
    url = "https://github.com/alexzielenski/Mousecape/releases/download/${finalAttrs.version}/Mousecape_${finalAttrs.version}.zip";
    hash = "sha256-VjbvrXfsRFpbTJfIHFvyCxRdDcGNv0zzLToWn7lyLM8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Mousecape.app
    cp -R . $out/Applications/Mousecape.app/

    runHook postInstall
  '';

  meta = {
    description = "Cursor manager for macOS built using private, nonintrusive CoreGraphics APIs";
    homepage = "https://github.com/alexzielenski/Mousecape";
    license = with lib; licenses.free;
    maintainers = with lib; with maintainers; [ donteatoreo ];
    platforms = with lib; platforms.darwin;
    sourceProvenance = with lib; with sourceTypes; [ binaryNativeCode ];
  };
})

