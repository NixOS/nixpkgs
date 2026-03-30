{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dylibhijackscanner";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/objective-see/DylibHijackScanner/releases/download/v${finalAttrs.version}/DHS_${finalAttrs.version}.zip";
    hash = "sha256-PnL/pVkzKvtlqDv7w7WXMGSqyaQk3unMi8V+Y/htco8=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R DHS.app $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "dylibhijackscanner-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/DHS.app"
      test -x "${finalAttrs.finalPackage}/Applications/DHS.app/Contents/MacOS/DHS"
      touch $out
    '';
  };

  meta = {
    description = "macOS tool that enumerates dylibs and detects hijackers per Apple guidelines";
    homepage = "https://objective-see.org/products/dhs.html";
    changelog = "https://github.com/objective-see/DylibHijackScanner/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/DylibHijackScanner/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "DHS";
  };
})
