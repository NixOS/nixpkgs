{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "langdock";
  version = "1.1.6";

  src = fetchurl {
    url = "https://desktop.langdock.com/global/stable/Langdock-${finalAttrs.version}.zip";
    hash = "sha512-38hJ2iCSRh20JJQbWaaxzvZImSB6icUiy2IuMrC0zGC85eRxdkEtoyaMLbsO+afIzGfqbnPaRJDVGIsV5ZseAA==";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  # Keep the signed app bundle untouched
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Langdock.app $out/Applications/

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-langdock" ''
    set -euo pipefail
    feed=$(${lib.getExe curl} -fsSL https://desktop.langdock.com/global/stable/latest-mac.yml)
    version=$(${lib.getExe jq} -r .version <<< "$feed")
    hash="sha512-$(${lib.getExe jq} -r .sha512 <<< "$feed")"
    ${lib.getExe' common-updater-scripts "update-source-version"} langdock "$version" "$hash"
  '';

  meta = {
    description = "Desktop app for the Langdock AI platform";
    homepage = "https://langdock.com/products/desktop";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      matsjfunke
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
