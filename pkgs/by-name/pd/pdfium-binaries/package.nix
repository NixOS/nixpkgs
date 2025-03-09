{
  lib,
  fetchzip,
  stdenv,
}:
let
  version = "6886";
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
        x86_64-linux = "sha256-8o2PgbyHqU1ST2clx2NRB6/E1eBWjuyx2oIVvc1/ujI=";
        aarch64-linux = "sha256-SUxtX7NMK+sMi5Fybc2P+bNrXET0TTBJTUhsMw0eBTc=";
        x86_64-darwin = "sha256-p4lHxr1Do3pLKXn2bOt8gh2R5KHPr4HpAM9hphFUimU=";
        aarch64-darwin = "sha256-Eb9I17GcuBaMAVKI9K0Rf/iD+nhBFDgYhWth46yU0xE=";
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
