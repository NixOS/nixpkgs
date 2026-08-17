{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7999";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      system = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
        aarch64-darwin = "mac-arm64";
      };
    in
    fetchzip {
      url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F${finalAttrs.version}/pdfium${lib.optionalString withV8 "-v8"}-${system}.tgz";
      hash =
        if withV8 then
          selectSystem {
            x86_64-linux = "sha256-tQP2pxChI6Gpw15jk5ctoc6KfmB6NvKK+K3ajwuU5UY=";
            aarch64-linux = "sha256-zohMZ5TGaIDYqu/9BgepAfZuJSbRLAUr9aLc0O8CTrY=";
            aarch64-darwin = "sha256-niaxW48kD2RZVKUWFL26JFhf2U3jWmwrLNxjDfqK9Ac=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-QF81GieX0wjiXldBOoLSOUXjt9Q0ULgv5UFjh53FPgc=";
            aarch64-linux = "sha256-bbbxOYJXYSzaGrMgOBlnDBiIKc5hxtuXFO8+c+ZCRNo=";
            aarch64-darwin = "sha256-fcjUV48HIPLB9mPr1GAmzNKQp8zQhpqQvsZUoAZndA0=";
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
    ];
  };
})
