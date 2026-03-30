{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "donotdisturb";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/objective-see/DoNotDisturb/releases/download/${finalAttrs.version}/DoNotDisturb_${finalAttrs.version}.zip";
    hash = "sha256-AA486PWr0TE7u2A8QBob4LXPTxFkTTbx1dOCdFB5/cM=";
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
    cp -R "Do Not Disturb Installer.app" $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "donotdisturb-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/Do Not Disturb Installer.app"
      test -x "${finalAttrs.finalPackage}/Applications/Do Not Disturb Installer.app/Contents/MacOS/Do Not Disturb Installer"
      touch $out
    '';
  };

  meta = {
    description = "macOS tool that alerts you when the lid opens or the machine wakes";
    homepage = "https://objective-see.org/products/dnd.html";
    changelog = "https://github.com/objective-see/DoNotDisturb/releases/tag/${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/DoNotDisturb/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "Do Not Disturb Installer";
  };
})
