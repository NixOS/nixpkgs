{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "deck-app";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/yuzeguitarist/Deck/releases/download/v${finalAttrs.version}/Deck.dmg";
    hash = "sha256-qfO4nIq6cJNNgDc0h9GCC7HiT/XqJ0jTf+ttN0NDhng=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;
  strictDeps = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Deck is a modern, native, privacy-first clipboard manager for macOS.";
    homepage = "https://deckclip.app/";
    changelog = "https://github.com/yuzeguitarist/Deck/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ myzel394 ];
    # Deck provides a CLI tool that can be enabled in the app settings.
    mainProgram = "deckclip";
  };
})
