{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  # also update rev of headers in python3Packages.pypdfium2
  version = "7390";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      system = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
        x86_64-darwin = "mac-x64";
        aarch64-darwin = "mac-arm64";
      };
    in
    fetchzip {
      url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F${finalAttrs.version}/pdfium${lib.optionalString withV8 "-v8"}-${system}.tgz";
      hash =
        if withV8 then
          selectSystem {
            x86_64-linux = "sha256-9GFHTurz02esE7M7tq/J/LAy1A+IFUj5Wx9Q8MwZDgc=";
            aarch64-linux = "sha256-xRvMyGN2w35yO0kCEONWqb/LBIp8d69fIFT1FLgITyI=";
            x86_64-darwin = "sha256-Ei996PPfpT99OzZyp1vrSZG8px38KZFBKpqDXrE6G50=";
            aarch64-darwin = "sha256-YJkcyb8tIwEsktP/R6C1ijAJqCsqeYQ7YUIrp0slozg=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-8mMVX+pGhY+WHri/uvNDoC1Dc0unjR3jVEd6e1+svbc=";
            aarch64-linux = "sha256-Jw0OHOSiGQHSx224RjMC/GJx9/GulTGg4KxuzQriRig=";
            x86_64-darwin = "sha256-oimUUPf7IvJDsNtWuKy6br/DU8ALkAVSVa9bCydE3qI=";
            aarch64-darwin = "sha256-z1flH9Zn3vEVqLTA6gs6fRElEBFCnCUDnbx0NMdsCR0=";
          };
      stripRoot = false;
    };

  installPhase = ''
    runHook preInstall

    cp -r . $out

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
    license = with lib.licenses; [
      asl20
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
