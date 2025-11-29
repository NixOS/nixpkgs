{
  lib,
  stdenv,
  fetchzip,
  python3Packages,
  withV8 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium-binaries";
  version = "7543";

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
            x86_64-linux = "sha256-hkxpWP51FqqlJVI1D9jmzPEDIJSf4ly2rgQfhk6JKfk=";
            aarch64-linux = "sha256-tGq6vtnL83lWyiZYBJBz7oQlynYGT9ML1oEf6BQ03dY=";
            x86_64-darwin = "sha256-/LzbjxnvNqF6yRb4RCwQMLOarzIb12E1YEjZRa+3780=";
            aarch64-darwin = "sha256-Dvmu3BK53v9uY7m8W4chfl0ZgcShaiwZDiUsFhmHoWc=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-r71gLGfTYey27UNWRgP4RAKeirpZh8m7zsXbBXjLFec=";
            aarch64-linux = "sha256-Q2w3hoQ1uWxmXZ/7lGlkzLsYKY++AAYr4TRqRD+Ni3Q=";
            x86_64-darwin = "sha256-x5EqlAwHXnKASJUVIf3u/rIjTETTwyMhBSccTcALSKI=";
            aarch64-darwin = "sha256-jKWY63gzO3bHJmDYU5pcHcIRsKIkb7FTHiNT2MnwXgY=";
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
