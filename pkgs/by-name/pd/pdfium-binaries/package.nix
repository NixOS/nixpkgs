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
  version = "7469";

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
            x86_64-linux = "sha256-N+XEigycJ7otr899Rx6eyGAGa3WTgJOXiIY+APKy1o8=";
            aarch64-linux = "sha256-FLuH1bxUU4ukzvO+rs+O8cqC5/yB3tTIp8Xe0mNg4jE=";
            x86_64-darwin = "sha256-B7Osq2Pa7HqyYyc226f2mHw2dYWOeQjdE5zFU7mpMVE=";
            aarch64-darwin = "sha256-kVk5awKvCmUdiUV7+/AThkCKaW8Vhk+zNhjcTzWe9VE=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-JzBvuDT0C3PVh1DF6NygLjkG8zLI/3K7FsYCtxqYslQ=";
            aarch64-linux = "sha256-MTl4umOVm51ntaMtntQ9lnepvzUcehuFtlnnKRoPxaM=";
            x86_64-darwin = "sha256-Qe/zoYKpenvsQfdhQ08IhT3obGZbMcKnx/oKNB0anJk=";
            aarch64-darwin = "sha256-sAFghkPvqP7aMSonpVOaEgqkEMP5bYI5PIs7xMYigT8=";
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
