{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  # also update rev of headers in python3Packages.pypdfium2
  version = "7323";

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
            x86_64-linux = "sha256-gHYAcPf3pBhujTOJ4D8hnR6NVnQASmkjAmFCL3lFRCY=";
            aarch64-linux = "sha256-TYBxz3TyZS9vcUudtnnUVDwqdzWaquup8oFBpWkk/iI=";
            x86_64-darwin = "sha256-DaRrhQ6nKcL53VGt9l3zeyEBwFwrZEVLTvZLp7hJEfk=";
            aarch64-darwin = "sha256-DsEqYvZmYeVd+H0XBksbKNtCBCMz/o5kmkExpjxjScw=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-ttgHvUK1ANvlJr+vxQ5+GmmadHYdmVa6A1boTTn59KM=";
            aarch64-linux = "sha256-yU24pTpdKw6p+7znKLtY5Nl6B8r61QtKlh5+y1Bo6P4=";
            x86_64-darwin = "sha256-pHj4pJsvlR0JctZNd5g4oZg8TK1cd4G4x4toYl4PFwQ=";
            aarch64-darwin = "sha256-g0fblY3vrQgry9PTKGQtFKELsLm+GdjUbApH1p+GRys=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
