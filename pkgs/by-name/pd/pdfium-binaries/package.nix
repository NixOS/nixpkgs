{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7363";

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
            x86_64-linux = "sha256-KbAJUdbT3XjLs68y4xwEG5w8o/89epkXSCKpQsyuNec=";
            aarch64-linux = "sha256-zvaTKszH5yT1afzs0W3LV1caN6gaCIJiKIh9bElfI48=";
            x86_64-darwin = "sha256-xGnmndTkYSIGn44Y4cfYW36QmkVAOhgIlcsWaRYFbCk=";
            aarch64-darwin = "sha256-NYY/YIVtSux4B6UZb7kkZs+GzxXNopmvtknw/HhVEQs=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-mlSmVeE1oDQ1OlW8K7EXk51r7GCbDXH2l/tbat2aiB0=";
            aarch64-linux = "sha256-YiCMdwQ2Y0F120iKW3ZkxJKvDgP/vpPw1ItmRnsnz9U=";
            x86_64-darwin = "sha256-I2fWQC+GKzZwqTPwXkl9vDJ/HIH3GKzD+kNaUDcNKuw=";
            aarch64-darwin = "sha256-AhYAr5SySWJO3jbvs+DvEZ/WaCJ+KhxpFVyOVsJxuXE=";
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
