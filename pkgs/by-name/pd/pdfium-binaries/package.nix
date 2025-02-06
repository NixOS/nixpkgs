{
  lib,
  fetchzip,
  stdenv,
  python3Packages,
}:
let
  # also update rev of headers in python3Packages.pypdfium2
  version = "6968";
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
        x86_64-linux = "sha256-jITBi7w8jhZVkwimFp4nmWpQahPWXAGIJj/zHe5TVCU=";
        aarch64-linux = "sha256-rDyLhRuRzw/R9Z1ZuSadXKJ+74U+RVJIC9NSCddd5lg=";
        x86_64-darwin = "sha256-ofqKS54ZKcXLVGEs2mhFGC4W7+d87JfhCS+HqcJkzTg=";
        aarch64-darwin = "sha256-g8iHsGVp/wCu4FU9ds6RBzabuMIONPA1H/M14BNjPu8=";
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

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (python3Packages) pypdfium2;
    };
  };

  meta = {
    description = "Binary distribution of PDFium";
    homepage = "https://github.com/bblanchon/pdfium-binaries";
    license = with lib.licenses; [ asl20 ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
