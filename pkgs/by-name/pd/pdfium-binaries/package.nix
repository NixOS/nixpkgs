{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7651";

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
            x86_64-linux = "sha256-0SrBAAPbfzJb61hts1NhJ0/JcqrrsEVmx8b1n3SJ1jY=";
            aarch64-linux = "sha256-Y0uam2fPA+sJa7duBoHxEfqzJDY1eJEpQ60BiBkIWzM=";
            x86_64-darwin = "sha256-SMYT+ypJeYSAVukG9VRlwUIOnqxP3+mMcLlHuYXpLZw=";
            aarch64-darwin = "sha256-omV1WT4Hkt/BpVqnTYHyoiaHDHuEINRoc+8V88S/QAw=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-yVUOUl1uq8xrkMxOIuK/7urwxLJ1joJnVFXkOS5AVko=";
            aarch64-linux = "sha256-fZR/2+jRd7VAOziUT61K3Pz7SXJV5ulOaDTm+b8Im1w=";
            x86_64-darwin = "sha256-V+VuKqUGq54Vv6qA+DxgbflA72xzWBenh1GXsLgrZwk=";
            aarch64-darwin = "sha256-qc2uKGarogKCMWcLWs7ML+Uv6oS91dN27G+DUt2Vjho=";
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
