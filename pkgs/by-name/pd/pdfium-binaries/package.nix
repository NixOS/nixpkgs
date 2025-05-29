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
  version = "7087";

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
            x86_64-linux = "sha256-nKHXcBTEp165g18HLzaNGfKt8MtTYpKBGNgwIpSO0u4=";
            aarch64-linux = "sha256-wip/ry42aDbyGiwYSUX8koxDuf88BLGZAmMZE0s+fL0=";
            x86_64-darwin = "sha256-7pUMfNFgGqQ8Dnox57sHfrKKke+i8CGEma4tePJaTDA=";
            aarch64-darwin = "sha256-o59kmTNC4nSCFLfww3E+4iIYs2kQ30yyFaX9f2Za7os=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-zn7QlTvChQa2mQCe5K+zEGVUtuD+l/jEtlKticrrSKg=";
            aarch64-linux = "sha256-080X72NNfKaanHeVtmxE/4uNV6Ue4f/1Mri/p3nOT8c=";
            x86_64-darwin = "sha256-XMStU0MN9ieCrLQnQL4/jKrNWxgQl9OtZHg9EmemPhU=";
            aarch64-darwin = "sha256-Q8R/p1hX6+JeVTFc6w7MC9GPNGqxlu6m+iawRIMndic=";
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
