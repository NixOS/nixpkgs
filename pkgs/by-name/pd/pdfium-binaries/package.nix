{
  lib,
  fetchzip,
  stdenv,
  python3Packages,
}:
let
  # also update rev of headers in python3Packages.pypdfium2
  version = "7137";
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
        x86_64-linux = "sha256-VyQ/bQjFuw6zeOhrJ8Cqr5IvH5gJpj5fnOfbVWUTzRM=";
        aarch64-linux = "sha256-ddohyaEwvPOheK2OMONqALdAWQbcXUuIJ0Z8na35jww=";
        x86_64-darwin = "sha256-etoc24I0mKnii/2RGU0K+50BQrL6hnMxwaoSZChvSJg=";
        aarch64-darwin = "sha256-lu3Jpd3nx2x8YVorf0tB1dCitqvk3IpBx5LbKusqS/k=";
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
