{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7529";

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
            x86_64-linux = "sha256-QEp7WaZ89wTiwIL/3Y03AyxeNgMGAd7gYBZkHoF2Mmw=";
            aarch64-linux = "sha256-kroK4a35b7ARBibPttc0aYEnBPssGmqTddy2rqB/z1U=";
            x86_64-darwin = "sha256-TQk2ViLfm3HfhPbUQ5U4s/DHvVhmNAysMnID6z9wFTo=";
            aarch64-darwin = "sha256-fUDWI/PL+Ofb+xjVGvYuwNnhO+4khS9sc3lVH0H9ojc=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-n5IGKnsC0w2ybISAwn4eyg1KJcU8hFhlkvW1SSOfpmM=";
            aarch64-linux = "sha256-Pi/PtPsOPsNvAFRa122Z9DnzFwRTSt+r2cA/cseyCBw=";
            x86_64-darwin = "sha256-M13gdnRbz3IT/Hmxpvcmc3a/mXTmZvtBtOzFpgB150Y=";
            aarch64-darwin = "sha256-1Vjn+gRjE/K0JfAzMg5QcrRQt38Utyez61AhEc7oyr4=";
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
