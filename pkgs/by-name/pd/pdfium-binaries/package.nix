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
  version = "7242";

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
            x86_64-linux = "sha256-FiIjbyDZTXD+Ryiq6hz3BYaW61Rue/Myn8GzXeK7DVU=";
            aarch64-linux = "sha256-fVKAy5XddyZMvpHltR4K9qOrWvhwE2HPCyGYzARJV2o=";
            x86_64-darwin = "sha256-3hqW3bYIwTrNutBc6KbOp5m30tqZgbPvk2xCOI/x8V4=";
            aarch64-darwin = "sha256-DZlgOsiasHWl9neIFUdlhN2a2DDTmu3uMDvgfVbohRs=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-kPd0hlh7LQB6E+Zq/5sta4E8zD0/S5uuKGxw3/tW310=";
            aarch64-linux = "sha256-aLMst4oQZJdW7zTQ0A1FAPOcVCJYUp3N2o8+1ErABQA=";
            x86_64-darwin = "sha256-FQN9ljgV733D2//d+hJyK1G1qtnORdL1a/2Nvf0RK30=";
            aarch64-darwin = "sha256-Fm36ZpCFIj05wWvVLFVolwpAHYGDfhPelEM92TeCm5w=";
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
