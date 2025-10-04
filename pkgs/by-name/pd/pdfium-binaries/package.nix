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
  version = "7428";

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
            x86_64-linux = "sha256-4KUwhzeav50jj9WqjlCrzDr4HADfNVN3kijq4OfcZ0g=";
            aarch64-linux = "sha256-S9kdVIUsyC6PurC2Uyz5bVwfyvaa4UcpJ/B2KgH8Z6E=";
            x86_64-darwin = "sha256-xuqkLhaWCroJdmAZ0PzMijaOGkeJy9nq9bGDI/qn9Z4=";
            aarch64-darwin = "sha256-sIeVKkxFyW9UStWUtYmESyUVKUFPxIM+ZKvSjjQ7aB4=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-zJfd4EeYeZA54JreouLin/hHy6r8qCXJi763NHpmyYc=";
            aarch64-linux = "sha256-Dlkfs7z6V7EcFqpVeABNnYD73s4a1SynsnfxS1mAjkc=";
            x86_64-darwin = "sha256-oJwF/S6LCta2HAO3sIFKHJWE9WFoN2zlo46S9pWyG5A=";
            aarch64-darwin = "sha256-mU7ncGqOMVKf9vO1WuQBRsoU1jAKGo+5h9VFMIf/0ME=";
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
