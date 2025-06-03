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
  version = "7215";

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
            x86_64-linux = "sha256-WoEblA/0LXm+o1y0D0BIVZrJr+SXS0eke1QwA3ZG29E=";
            aarch64-linux = "sha256-K1YNip+F6XjauGgCW5hfDQ7iBkEjp1+QMHw5/rrrSrg=";
            x86_64-darwin = "sha256-0kGoel8zRjajgP5A8ENzKlfMHlO8k7IsSv4OUTsZ1qQ=";
            aarch64-darwin = "sha256-Wncl3jNsveDvbqE/vb3dJyFc/cUEWpHcV5WfRD3c8p8=";
          }
        else
          selectSystem {
            x86_64-linux = "sha256-X9CXlcI5FhT1zk227aXK1EjsOnFAkJYBWWcECnX42TA=";
            aarch64-linux = "sha256-hPQlgUx0tpEZH/lMfrHjdDz4bdOdDXwuJ0o8E7/zLhs=";
            x86_64-darwin = "sha256-hC3REfX76eXXFNkAWIpYtyn0hlnMBjBLFySkO9Xq7gE=";
            aarch64-darwin = "sha256-iNDasP+PLldsJvYcyKGu+7Lq3sx6qa/KWfxgUhCwGsw=";
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
