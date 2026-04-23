{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7749";

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
            x86_64-linux = "sha256-I3JTNnqXpDHwl+sOS/AlPj4znG2OFIqRxtJNhXD+w6I=";
            aarch64-linux = "sha256-PBkwxcjsqeEElNC+V74h4P1e508IB/zXjGoQuwK6Krk=";
            x86_64-darwin = "sha256-aumdSND6Lefr6GgmWBSX4pQhZj8jJIABi6VJSqKNin8=";
            aarch64-darwin = "sha256-DpoPHGaFkjfOa3tXItYLeJpTLfRXOrjlN/+eyPEcgOQ=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-0VaBPO4angdRqerquTjqizZWvGxrRP8k7DZXLw8Yqaw=";
            aarch64-linux = "sha256-h7JJxmCg9GIaVMajNZb+AeClIeX8w9XWM2RYqGhPoUY=";
            x86_64-darwin = "sha256-1Or4cuxvx13Z70kIj7Q1DM1hg/bW5SPAGEDEtnBU6YI=";
            aarch64-darwin = "sha256-rJqrpCo+5bzqyUsRubGOsBZ8orV1dSuXfjADFJmxBOw=";
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
