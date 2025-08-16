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
  version = "7350";

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
            x86_64-linux = "sha256-1By0pFDtY2Ds8dYq9L+dAkFm9EJDo2fc5YhgJ+wDyvM=";
            aarch64-linux = "sha256-wNITk6wSleT+eGBngyfbVwY03l1gkh5yuNoNN2dHNns=";
            x86_64-darwin = "sha256-/UU31fzPlWM4a8EEy4O8d0cAqTmNT0ShPooSyZEzRTA=";
            aarch64-darwin = "sha256-hxkLS/+aZ1MKCKoy2nIvZmF5PqjesceaYPJIbgtzq0w=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-jnYCYtnGx467v6raiit4y7Tov6yzWZInFHzBr3D2DFE=";
            aarch64-linux = "sha256-vNoi+mfQc02/IMpvBlWDdvi5Tce691xf9sFImy6q+c8=";
            x86_64-darwin = "sha256-F01SdSl+2P1w0HAL/CI43vgHuoNyy4uSwHPjBmVSmj8=";
            aarch64-darwin = "sha256-ES6on664mXZsIg8SnCbHgeqCXCNfoVUNnMnqSd8BphM=";
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
