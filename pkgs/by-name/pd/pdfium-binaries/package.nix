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
  version = "7483";

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
            x86_64-linux = "sha256-84or+yv1BhcgjUf/91qk3a9dek3Z6eNWtQzg+qsQ84s=";
            aarch64-linux = "sha256-E8DDYNG4YV57J50OshFm28UUGrYfC0twWNp3tqoxuT8=";
            x86_64-darwin = "sha256-c/qS1USa8e02LaUfd24IH4Cu95dONG2EMHrsnYtml7E=";
            aarch64-darwin = "sha256-/I5VIoMpPYndIGW6cS2bdfoghQvvbVpEKr7c0hlqdf0=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-9Z15zVHT9YiLWjcWtASF1lnNJfVVEzxXPLYisuZ28Dg=";
            aarch64-linux = "sha256-IjzwauIEWROQVkXwCD7JkjuSVZzwBqkWMxWgDRLskIQ=";
            x86_64-darwin = "sha256-bAx4ODr6IYiBQtvum6JCeGj2/DMAINXUgzZ5txiUZ2I=";
            aarch64-darwin = "sha256-KkvuDrNlRW//tw4+kZ4H/zvpRsTCG545JcHWOu1AkYQ=";
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
