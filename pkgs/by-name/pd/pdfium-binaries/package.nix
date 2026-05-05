{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7811";

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
            x86_64-linux = "sha256-sHue1Au96MBotTDgDiIr0h5m8gjLvIpGC7eDyyaXRfw=";
            aarch64-linux = "sha256-lWTLrHbDLFWW75TFC2EwHVAWSKIfrqzZWJ/depJ6d+4=";
            x86_64-darwin = "sha256-TUXDvrLIZVzqD5LviL6uKnlS+3fJn2lnW9AS1UDbRII=";
            aarch64-darwin = "sha256-QaQaKfMX+q+j2aeYd0BbOiKfaDvsAee/6IEFDNHwu4o=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-RP0JPlJBQGInTx/1O4ARjgCHFQVY1e8C/8lkWWVxivQ=";
            aarch64-linux = "sha256-GqDNtXYqfBwXl/pYvIZ28hCVDtXYVQy7RkwutAZ37OE=";
            x86_64-darwin = "sha256-XF2n4ugYmcxEPE8xHNSTjLL3BizrcU1i6jnEiDbkN68=";
            aarch64-darwin = "sha256-Tyg/rzvpR9OTVvngw0G0WDDq07CjFWwzpb4T20yIEDE=";
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
