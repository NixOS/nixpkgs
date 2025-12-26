{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
  versionCheckHook,
  writeShellScript,
  xcbuild,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "betterdisplay";
  version = "4.0.4";

  src = fetchurl {
    url = "https://github.com/waydabber/BetterDisplay/releases/download/v${finalAttrs.version}/BetterDisplay-v${finalAttrs.version}.dmg";
    hash = "sha256-njk1epuekOiBN8Exkxs9J2OHVP4xu4on42F+TPlW75M=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  buildInputs = [ undmg ];

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv BetterDisplay.app $out/Applications

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    ${xcbuild}/bin/PlistBuddy -c "Print :CFBundleShortVersionString" "$1"
  '';
  versionCheckProgramArg = [
    "${placeholder "out"}/Applications/BetterDisplay.app/Contents/Info.plist"
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unlock your displays on your Mac! Flexible HiDPI scaling, XDR/HDR extra brightness, virtual screens, DDC control, extra dimming, PIP/streaming, EDID override and lots more";
    homepage = "https://betterdisplay.pro/";
    changelog = "https://github.com/waydabber/BetterDisplay/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
  };
})
