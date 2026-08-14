{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "instant-space-switcher";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/jurplel/InstantSpaceSwitcher/releases/download/v${finalAttrs.version}/InstantSpaceSwitcher-${finalAttrs.version}.dmg";
    hash = "sha256-48DH2Hu/XhLPr8jP2ArmLJLFbJmIupkrlqlFOsNnL7g=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R InstantSpaceSwitcher.app "$out/Applications/"
    ln -s "$out/Applications/InstantSpaceSwitcher.app/Contents/MacOS/ISSCli" "$out/bin/isscli"

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;

  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native instant workspace switching on macOS. No more waiting for animations";
    homepage = "https://github.com/jurplel/InstantSpaceSwitcher";
    changelog = "https://github.com/jurplel/InstantSpaceSwitcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    mainProgram = "isscli";
    maintainers = with lib.maintainers; [ myzel394 ];
  };
})
