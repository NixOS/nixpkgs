{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7592";

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
            x86_64-linux = "sha256-42ME9xvOfRXGxNgtt1Mogj8w0m8nabuGgr0/r/oIRWg=";
            aarch64-linux = "sha256-lgZ5qpipC8cNTE2QsbH0LEeHhWzL1jfNduYwx8LaH9U=";
            x86_64-darwin = "sha256-hzbJSMRQKyPgEy0zK9gBdkf5r10BbUS99bqfq4EkN3Q=";
            aarch64-darwin = "sha256-6cRpN/5YAaf9LmDdWHnYFoUbkuSBTFCK1FbGyr8Ul5c=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-H1ncxCDTtp1lAMZ0PkLJj3cvNt46sCxXFRXEgkcn/pQ=";
            aarch64-linux = "sha256-F525D9WHvcwMYP+mq9sIJCSRXi8tM3nxeLhuBp+2+Wc=";
            x86_64-darwin = "sha256-6Wwr1KwJ6RZ+2yjLyPZpN8/JmbdFTtzRcsZm4cB9S8A=";
            aarch64-darwin = "sha256-Vq9F0VzdJ7MjWGF5oRRhjZa4cTIjyJ3BXqYjiy9oi68=";
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
