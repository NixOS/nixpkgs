{
  lib,
  fetchzip,
  stdenv,
  python3Packages,
}:
let
  # also update rev of headers in python3Packages.pypdfium2
  version = "7087";
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
        x86_64-linux = "sha256-zn7QlTvChQa2mQCe5K+zEGVUtuD+l/jEtlKticrrSKg=";
        aarch64-linux = "sha256-080X72NNfKaanHeVtmxE/4uNV6Ue4f/1Mri/p3nOT8c=";
        x86_64-darwin = "sha256-XMStU0MN9ieCrLQnQL4/jKrNWxgQl9OtZHg9EmemPhU=";
        aarch64-darwin = "sha256-Q8R/p1hX6+JeVTFc6w7MC9GPNGqxlu6m+iawRIMndic=";
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
