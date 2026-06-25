{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7906";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      system = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
        x86_64-darwin = "mac-x64";
        aarch64-darwin = "mac-arm64";
      };
    in
    fetchzip {
      url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F${finalAttrs.version}/pdfium${lib.optionalString withV8 "-v8"}-${system}.tgz";
      hash =
        if withV8 then
          selectSystem {
            x86_64-linux = "sha256-L6Q88PpVUae3ZI1UwTURgTmfhy+B6jJST7A805V79v8=";
            aarch64-linux = "sha256-i0s3+qbeWPlPbZrfNKzPM1/MIvDv1tRmDN41v4GcyVY=";
            x86_64-darwin = "sha256-BJ+E+E2uUV+nT0b2iDoNBZ5G4PYOig/94mw3fuj4LVI=";
            aarch64-darwin = "sha256-FSnV72qB6dqdFGgI+r/716qSQgBRUUwJabXzjRdIY+w=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-nH744Bb5y3IZe3wKuItGIGHAezolDmToYk72dM9b7r0=";
            aarch64-linux = "sha256-c6aDw02FJPl9n3N5da1ii8bCuQwHmV7Y1laNRvhkvwM=";
            x86_64-darwin = "sha256-jhMyXGgO6WE5YyVG33RAyineKueL0VbaKojSsl5shCs=";
            aarch64-darwin = "sha256-ZGob8O6Of0F89NdviIEl4XGT0RT4T2nXzjbdFYKjFUE=";
          };
      stripRoot = false;
    };

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (python3Packages) pypdfium2;
    };
  };

  meta = {
    description = "Binary distribution of PDFium";
    homepage = "https://github.com/bblanchon/pdfium-binaries";
    license = with lib.licenses; [
      asl20
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = [ ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
