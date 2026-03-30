{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "knockknock";
  version = "4.0.3";

  src = fetchurl {
    url = "https://github.com/objective-see/KnockKnock/releases/download/v${finalAttrs.version}/KnockKnock_${finalAttrs.version}.zip";
    hash = "sha256-HhNx/262LghmJmoHROkKo73GsizKBZmvvTMN31JmPGk=";
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
    cp -R KnockKnock.app $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "knockknock-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/KnockKnock.app"
      test -x "${finalAttrs.finalPackage}/Applications/KnockKnock.app/Contents/MacOS/KnockKnock"
      touch $out
    '';
  };

  meta = {
    description = "macOS tool that enumerates persistently installed software (login items, launch daemons, extensions)";
    homepage = "https://objective-see.org/products/knockknock.html";
    changelog = "https://github.com/objective-see/KnockKnock/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/KnockKnock/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "KnockKnock";
  };
})
