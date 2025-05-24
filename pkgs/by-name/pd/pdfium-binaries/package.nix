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
  version = "7188";

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
            x86_64-linux = "sha256-euBkUCAcGXIxcbxKfumpjLTG4LNeAkpo89MMWZuxkws=";
            aarch64-linux = "sha256-4L0rzdYID6/yVL9UUGc0avMn0KbkT0XJIyaFGh9cv6M=";
            x86_64-darwin = "sha256-DdrpVhSNJO+yAY9py6MzDkKFFYzi9m2JpHyaRM52mMY=";
            aarch64-darwin = "sha256-9NsVPGpf4GJqIm9Abdia0lTovUUlnkVEYnW0g0zxgos=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-H6bKw84GxKwPpJb0dEzdt25LUc2XkhuwmY/XT9FtGog=";
            aarch64-linux = "sha256-+zWiiOGduAxYqEMdEzs5EFa2WCZO37/XlfblXwCnq+M=";
            x86_64-darwin = "sha256-GjyYjyEHLWFuAEgGCbfB2KWmbUAXAedaqXeuCm8VZ08=";
            aarch64-darwin = "sha256-RQE5Jq+9YtLmBy14ZsEWF5UstWohERAA76GpzbBzQAA=";
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
