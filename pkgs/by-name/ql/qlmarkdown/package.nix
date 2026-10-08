{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "qlmarkdown";
  version = "1.5.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/sbarex/QLMarkdown/releases/download/${finalAttrs.version}/QLMarkdown.zip";
    hash = "sha256-duQwlY87yWKn5RXEaPqZz8oICIsHid8m1i5V7+5bIf4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R "QLMarkdown.app" "$out/Applications/"

    ln -s \
      "$out/Applications/QLMarkdown.app/Contents/Resources/qlmarkdown_cli" \
      "$out/bin/qlmarkdown_cli"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Quick Look extension for Markdown previews on macOS";
    homepage = "https://github.com/sbarex/QLMarkdown";
    changelog = "https://github.com/sbarex/QLMarkdown/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kinnrai ];
    mainProgram = "qlmarkdown_cli";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
