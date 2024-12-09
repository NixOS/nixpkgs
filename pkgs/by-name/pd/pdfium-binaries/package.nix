{
  lib,
  fetchzip,
  stdenv,
}:
let
  version = "6872";
  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system};
      suffix = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
        x86_64-darwin = "mac-x64";
        aarch64-darwin = "mac-arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-JhAW1Ot4ncLiEz/Y83D/capJ+H46GybYnWHpMChX6F0=";
        aarch64-linux = "sha256-/8o+v8fIXYK8N7xdC14/fWk3LOr13xyjadMXJgploek=";
        x86_64-darwin = "sha256-nVu3JhvjnqhCpNDSBzzZA1PHbT2y5b+kEeu4ZPqgf4Q=";
        aarch64-darwin = "sha256-IyoeuNno+Y8nLi1u9tjl75ZJiULrnKyShe3oaSY9GF4=";
      };
    in
    fetchzip {
      url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F${version}/pdfium-${suffix}.tgz";
      inherit hash;
      stripRoot = false;
    };
in
stdenv.mkDerivation {
  pname = "pdfium-binaries";
  inherit version src;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ./ $out/

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Binary distribution of PDFium";
    homepage = "https://github.com/bblanchon/pdfium-binaries";
    license = with lib.licenses; [ asl20 ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
