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
  version = "7281";

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
            x86_64-linux = "sha256-2C+BIsOzKMpmModL3Mw2AZdf5TDxNNIPw5UTQLqeBRw=";
            aarch64-linux = "sha256-xgz6cpXDkCx1JNSiHSH3MzxFXX+aZIGzhGXwgJbChZ8=";
            x86_64-darwin = "sha256-aN1MHi7/uF8WQbyNOGiAiifUlQB07Mb9bR3ZotmH3Fw=";
            aarch64-darwin = "sha256-QApvWqEGMxxF4IE+YpMv7LP2kDrEt0w5G0aXqdkxBwc=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-E3NiYVUYMpCEV02rEdM6TOXk8PMJAvbvNFjULiUvwzQ=";
            aarch64-linux = "sha256-cCWmK3MWth4lMZcOLbpqH6S3Oppl/qmDwxxFxzCxIPw=";
            x86_64-darwin = "sha256-a+8m9Xc2o7/RMIGOMqfWsnidgU19AlPPe2JylC/0lLg=";
            aarch64-darwin = "sha256-P0mZrhKTEStwJC+HOicUFWEckcbDuOTAiAqXwv15K/M=";
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
