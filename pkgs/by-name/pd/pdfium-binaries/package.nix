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
  version = "7401";

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
            x86_64-linux = "sha256-y86k2KsXGES/IzfpliUcBA4EmAV2itGBhtx8tfSCupI=";
            aarch64-linux = "sha256-rnachJ1C4fyRiquRt7cbAnLmD1NmFGsHEiFXIxONvak=";
            x86_64-darwin = "sha256-hT4zQr8PLjRnJmVbrVSRlSvcoEbR/096mES+dpIjza8=";
            aarch64-darwin = "sha256-9LTiHi2I3IYDrFcHUBfjJHLKQ/afGjn/qoFK9EHXR1E=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-nqmbxQevdNcFSyo5+XSwXMkpMEG3DQoMBiyOmcaoFE8=";
            aarch64-linux = "sha256-2oBMSsagffMBk1+Eu2OWVYV5CdmvT+3IH2//GYCdqvQ=";
            x86_64-darwin = "sha256-KOd1hml80mwF4pTUKu1l/Z2TupFsidaUIzpG7+qXXN0=";
            aarch64-darwin = "sha256-seit1BvWO4nrLzQQ9W2cNMkp9jncai4zm83J6R89ROE=";
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
