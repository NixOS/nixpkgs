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
  version = "7295";

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
            x86_64-linux = "sha256-OYfCOeHoQV2X+5Q7syfkcePIfmLbdUnrTQLF6+OqexA=";
            aarch64-linux = "sha256-6cXd1KDdUP5ozEheOwrM9RcGF7PyIDiYm6L6WeBAFVY=";
            x86_64-darwin = "sha256-krL1K/TsV+DgK/sJdKD/8a1e2K8KgjKCZ5WMzCPuQNY=";
            aarch64-darwin = "sha256-/voFN7rmOot6SjsWGyf5OLQJYvnQob7QrQ2sgWKSP5s=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-eVNzvNR9ZbRKUMC3FFKGX8hDOxD+tOz/ygwxqkch/I8=";
            aarch64-linux = "sha256-iJiFAAxcGKS0njLEJCOgLJbboJSJmJ+j/dbJTOfnR/M=";
            x86_64-darwin = "sha256-NxDl22IB4QOQoTrsKM4XpZLMhW+Q7nOeYDLNJR387sM=";
            aarch64-darwin = "sha256-3rZJxxTFx4tVSMVCtYPtMjWvM1Fl1v/bKLiU9LHpXe8=";
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
