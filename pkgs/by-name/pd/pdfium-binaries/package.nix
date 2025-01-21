{
  lib,
  fetchzip,
  stdenv,
}:
let
  version = "6941";
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
        x86_64-linux = "sha256-9dD4/OjWvUkm7HAOS/jBrtDXiB4LSfEH5j8S6iMI2Go=";
        aarch64-linux = "sha256-VpeRfZ1aFVjJlnUO0C+FNwkaXDdHvZSya7MDj90YPmo=";
        x86_64-darwin = "sha256-qsFSzksWJXN1F9AmWBQm8hXRyIEs3d9WaeD/7ZjQN7M=";
        aarch64-darwin = "sha256-zYhz63VLHJu9vszY2PxWHwAmSgMnvD2baDsK+TsvvyQ=";
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
