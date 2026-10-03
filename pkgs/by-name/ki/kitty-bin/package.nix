{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kitty-bin";
  version = "0.49.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/kovidgoyal/kitty/releases/download/v${finalAttrs.version}/kitty-${finalAttrs.version}.dmg";
    hash = "sha256-5SS4lBRdict2tYTjqWkRlq5Wv6MdUThKRKp3QlK3zvc=";
  };

  nativeBuildInputs = [ _7zz ];
  sourceRoot = ".";

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
    mainDarwinApp = "kitty.app";
    maintainers = with lib.maintainers; [ carlossless ];
  };
})
