{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "reikey";
  version = "1.4.2";

  # Upstream publishes installers on Bitbucket (no GitHub release assets).
  src = fetchurl {
    url = "https://bitbucket.org/objective-see/deploy/downloads/ReiKey_${finalAttrs.version}.zip";
    hash = "sha256-zu4uzo3eHh2NSYql2Xgtv1pisySQNzLgipfeCGgRRGs=";
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
    cp -R "ReiKey Installer.app" $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "reikey-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/ReiKey Installer.app"
      test -x "${finalAttrs.finalPackage}/Applications/ReiKey Installer.app/Contents/MacOS/ReiKey Installer"
      touch $out
    '';
  };

  meta = {
    description = "macOS tool that detects keyboard event taps used for keylogging";
    homepage = "https://objective-see.org/products/reikey.html";
    changelog = "https://objective-see.org/products/changelogs/ReiKey.txt";
    downloadPage = "https://objective-see.org/products/reikey.html";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "ReiKey Installer";
  };
})
