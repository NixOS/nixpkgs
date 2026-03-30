{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ransomwhere";
  version = "2.1.2";

  src = fetchurl {
    url = "https://github.com/objective-see/RansomWhere/releases/download/v${finalAttrs.version}/RansomWhere_${finalAttrs.version}.zip";
    hash = "sha256-CqH+Mpnz1uurMMlBCVHPvEzO5oiptHV+Ser9K4PCohQ=";
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
    cp -R "RansomWhere Installer.app" $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "ransomwhere-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/RansomWhere Installer.app"
      test -x "${finalAttrs.finalPackage}/Applications/RansomWhere Installer.app/Contents/MacOS/RansomWhere Installer"
      touch $out
    '';
  };

  meta = {
    description = "macOS tool that monitors file I/O for rapid encryption typical of ransomware";
    homepage = "https://objective-see.org/products/ransomwhere.html";
    changelog = "https://github.com/objective-see/RansomWhere/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/RansomWhere/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "RansomWhere Installer";
  };
})
