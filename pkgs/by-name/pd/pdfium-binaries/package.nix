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
  version = "7455";

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
            x86_64-linux = "sha256-zW9dGHX9iyJZjW5TYeVZu/IN1+5YJJtx6zc3RPeuVKk=";
            aarch64-linux = "sha256-Z+Gz+kvQqeuvsUiUj+lFu3KTOWZXMOIDDEhDO/wBjXU=";
            x86_64-darwin = "sha256-5TTtJFxgzphO/AgG2nz8baMR8eM3QhXTDdgcXUCtU5M=";
            aarch64-darwin = "sha256-bXSlAPl0fsR40p9tlOa7AWcApHUA+XWTdBah8J3OPAU=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-/DiaA5StiAx8jvCxRALL5GYgr+v3WB24YV1SL2f6XfU=";
            aarch64-linux = "sha256-iKJLYfGrSdm6JC+hiB83TSb4ijdv9siGFuNL06kBz4E=";
            x86_64-darwin = "sha256-jFLtns5XRwKk/jOcHoLLSXzy63up/LLSiRrCsFPW4uw=";
            aarch64-darwin = "sha256-A7zsAuydKWctdfq/TqmP8gI2fQEu8ImervBs9fFuBIk=";
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
