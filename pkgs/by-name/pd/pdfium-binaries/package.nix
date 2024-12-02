{
  lib,
  fetchzip,
  stdenv,
}:
let
  version = "6721";
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
        x86_64-linux = "sha256-SHCYdw3X8Uy9CgT8SN90FKdPKIk6VZFjIb6NYfOgoCo=";
        aarch64-linux = "sha256-RqyzxQ2RnBuoFBAxJVC8x/XDpJJWdJ45dJXV/Yzh7pM=";
        x86_64-darwin = "sha256-7XuBlG2pUtSN5kdcTTLbijEHHX5IU5kTj1aW8ZHHS2M=";
        aarch64-darwin = "sha256-ZNsQkay8ZF2RQ6dKJ24GawIthjFgB5TUa08LNKpZv1A=";
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
