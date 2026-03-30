{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  runCommand,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blockblock";
  version = "2.4.2";

  src = fetchurl {
    url = "https://github.com/objective-see/BlockBlock/releases/download/v${finalAttrs.version}/BlockBlock_${finalAttrs.version}.zip";
    hash = "sha256-0jbL6Pk6+KPJ9MgCzFOLmSd0kzhM+2kjSbug1aDPB+k=";
  };

  nativeBuildInputs = [ unzip ];

  dontFixup = true;

  unpackPhase = ''
    runHook preUnpack
    unzip -oq "$src" -d .
    runHook postUnpack
  '';

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R "BlockBlock Installer.app" $out/Applications/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      has-installer-app =
        runCommand "blockblock-test-has-installer-app"
          {
            meta.timeout = 60;
          }
          ''
            test -d "${finalAttrs.finalPackage}/Applications/BlockBlock Installer.app"
            test -x "${finalAttrs.finalPackage}/Applications/BlockBlock Installer.app/Contents/MacOS/BlockBlock Installer"
            touch $out
          '';
    };
  };

  meta = {
    description = "Continual protection by monitoring macOS persistence locations (launch agents, daemons, cron, etc.)";
    homepage = "https://objective-see.org/products/blockblock.html";
    changelog = "https://github.com/objective-see/BlockBlock/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/BlockBlock/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
