{
  lib,
  fetchzip,
  stdenv,
}:
let
  version = "6899";
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
        x86_64-linux = "sha256-JPXgjdGfQK1BztK3opqKfg5P2lAnmkcVj3qk2Ck8vHg=";
        aarch64-linux = "sha256-za1d1jKM3LdeBFttBBHQ+Nx1O4KC6FFwotuRHTj8tFk=";
        x86_64-darwin = "sha256-K2Sr4z4+WWmK9OxvkZB0k9LQDxCNnUvL0RArG5v2aYs=";
        aarch64-darwin = "sha256-wLa61Af4G47AE99M+uPlBjR2rdP5yUenoW9gsrOmZpw=";
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
