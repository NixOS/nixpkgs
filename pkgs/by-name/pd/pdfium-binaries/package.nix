{
  lib,
  fetchzip,
  stdenv,
}:
let
  version = "6927";
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
        x86_64-linux = "sha256-hx9+3/CD2xdsu/jm3St3UPXpAzySrgtC14UTQ5pkHPg=";
        aarch64-linux = "sha256-CEtviohWUR2/gUBGFq6dkMb0U68CVaTopcI5Xgv7Bks=";
        x86_64-darwin = "sha256-H4fVtDUuqJxeh37oMXcVuCpGth/WLXk8p8/3PfjWYgM=";
        aarch64-darwin = "sha256-FlyG1Qcl4G3ZVZoVJE3U2CNJoXKr8+1O747XjDq/Eog=";
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
