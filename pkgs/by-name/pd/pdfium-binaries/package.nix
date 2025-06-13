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
  version = "7228";

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
            x86_64-linux = "sha256-yAdDPLwfK+OVG73bIdKCn4QypNwLbuJ+Ul49fvLBcy4=";
            aarch64-linux = "sha256-EwvewSXXakLpBeC9MH32LIJXrTL6oVArbW4dhiaKPvY=";
            x86_64-darwin = "sha256-ef22SpP2QBgHwRMI1gUgYThs1Y2a6Y9xduOpufvQyNo=";
            aarch64-darwin = "sha256-pzSEcZGkYLjDYJSayym4n19eL/ChruVN2j8aQt8RSH4=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-7oBHzCu70F/iebQWP3Qr8P8XfHSI2mgbfFc9JyRs8yo=";
            aarch64-linux = "sha256-jgtya9WRy0pa+iVYyR+UIpCCiYmJpDit/8B4l1C2IDs=";
            x86_64-darwin = "sha256-t5EkH5AAmZ9Nk3GjO7bmGwmq9eIs4A/NjEBkqoJ4Vsk=";
            aarch64-darwin = "sha256-RdJNyG4PFyCtpoB5zl902rBDgNM0LuURyeK1IpJQ4Nw=";
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
