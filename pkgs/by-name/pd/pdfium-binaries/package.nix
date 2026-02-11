{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7643";

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
            x86_64-linux = "sha256-u44789oMKbBQ6USu4BnyoL4ZcCKDVkh81kOku9ZfloE=";
            aarch64-linux = "sha256-w+WI4+aESiBafPv4bbvwVqptecenzEj3M9wSH43n294=";
            x86_64-darwin = "sha256-0cPMIu8NDrnDd/4g0eL0j0jV9bzQCh36Ahx4mC/Hw9E=";
            aarch64-darwin = "sha256-R09JnjpcQMMfjbhFzRwE4/KXb9FCXzt/APM+oEUdknk=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-IpiNeuB5fOm2hYBfjydrg4G00xtvJQEqZJIzxHtzwac=";
            aarch64-linux = "sha256-NgboVIUuntEO/CyXcTJB8Gn9H1B5Z0GEfR7FhCFbHko=";
            x86_64-darwin = "sha256-fBatwgVRO4TawMAd0MaXxvgX+OLln+K10RjsGsvPLBs=";
            aarch64-darwin = "sha256-Sqrt5V0IxYuZmy1w9faDrESkoI4QNhtKS+GHY0ushGA=";
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
