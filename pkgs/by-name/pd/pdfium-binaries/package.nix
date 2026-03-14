{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7725";

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
            x86_64-linux = "sha256-AGYf8XQgtCz0bWyBmbQ7T05BTyQohSnM7OHlMC+5OTs=";
            aarch64-linux = "sha256-Ap5xHYHmFd3O6rkGHlinG8GL1S7/svIBORBPb8H2NQk=";
            x86_64-darwin = "sha256-aXkezqK2NmqCgMsMeH47JhcFT8nVzmO7+Z5A8nYB9IA=";
            aarch64-darwin = "sha256-b5V0N6PTEwPLkWISBKzQhDcqcsMbw9iPTuTvCfJ5lmw=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-RZ/8Mpy2zDnWLwBtR7KZ6O+j0lOPiIepfBPY+WRRkkc=";
            aarch64-linux = "sha256-t6o59a931GdZ8iAnNxVLZpT+eqPFCytC1vwzpsgk3Tg=";
            x86_64-darwin = "sha256-d2fdpyLDlUtsAMcsSvtMYKN4M9h1WfxyWLb8lo9vBHY=";
            aarch64-darwin = "sha256-8vet/4KjzlyHnWtNQHHtSx3WHRmeWc6iQ8EKqTW4SI0=";
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
    maintainers = [ ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
