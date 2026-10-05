{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "instant-space-switcher";
  version = "3.1";

  src = fetchurl {
    url = "https://github.com/jurplel/InstantSpaceSwitcher/releases/download/v${finalAttrs.version}/InstantSpaceSwitcher-${finalAttrs.version}.dmg";
    hash = "sha256-rsy241SZcA1Ot/cdfRKwrFnRtCfLMV8nW6HfA9nJ5eo=";
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
