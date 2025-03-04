{
  lib,
  fetchzip,
  stdenv,
  python3Packages,
}:
let
  # also update rev of headers in python3Packages.pypdfium2
  version = "6996";
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
        x86_64-linux = "sha256-DAu9t7PA8R3F2BotYaoPLoQFMkDIdJOnf4ljkJYMXxI=";
        aarch64-linux = "sha256-pNXBX0t6+ShaXGTSmM6J1UWaTLW/ZXoyfF7/gWl7rhc=";
        x86_64-darwin = "sha256-GlEoDifWTVC2tAVoHmkRpVdV+V6vsPUkZZVYP15oeXc=";
        aarch64-darwin = "sha256-OtUpNxo7HvrEIWSdCWC6MVf0fLQL2vqovhtRMzrrb5I=";
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
