{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kitty-bin";
  version = "0.47.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/kovidgoyal/kitty/releases/download/v${finalAttrs.version}/kitty-${finalAttrs.version}.dmg";
    hash = "sha256-tTubGKJ9U61Eol3Wd2/ejEdIe04QOsUNaCrx7o57d+0=";
  };

  # undmg can't read the APFS dmg; -snld keeps the .app's symlinks intact.
  nativeBuildInputs = [ _7zz ];
  sourceRoot = ".";
  unpackCmd = "7zz x -snld $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R kitty.app "$out/Applications/kitty.app"
    ln -s "$out/Applications/kitty.app/Contents/MacOS/kitty" "$out/bin/kitty"
    ln -s "$out/Applications/kitty.app/Contents/MacOS/kitten" "$out/bin/kitten"

    runHook postInstall
  '';

  # leave the signed bundle untouched so its signature stays valid.
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "Fast, feature-rich, GPU based terminal emulator (prebuilt signed macOS app)";
    changelog = "https://github.com/kovidgoyal/kitty/blob/v${finalAttrs.version}/docs/changelog.rst";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    mainProgram = "kitty";
    maintainers = with lib.maintainers; [ carlossless ];
  };
})
