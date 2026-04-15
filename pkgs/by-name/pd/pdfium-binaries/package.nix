{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7734";

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
            x86_64-linux = "sha256-ovbxiOwsmBUddbuTreVvhJeHMYd4dKu+rACDELsRC90=";
            aarch64-linux = "sha256-wMddHbzxCs21dzZhLjpLEviplFOzHukrRRbCPMOTrDs=";
            x86_64-darwin = "sha256-+UsFsft9WKd0LrDKbdxuKlHxNsfhzOIWvm8Br0MlNgc=";
            aarch64-darwin = "sha256-MDE27+uIhqkSe76xtx/sHt++OQtXXAueq10KrwYVJ8Q=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-us1UjIhdsRTSGJOkasLdMyIRKdHXKr21hY2+NOIKVH4=";
            aarch64-linux = "sha256-wHZVPH/c+jsxcClWznox/wnlKlTyUeKqdQxujdD67XU=";
            x86_64-darwin = "sha256-+Umu2SsuO9lJGngkBVyuAvg4wu9d/OCsSabQ7F4U55U=";
            aarch64-darwin = "sha256-pHEK9QC2DMZoRnTGc6NfVjCxaZYmCsh3RqHdSCdZ0Cs=";
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
