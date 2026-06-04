{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-meera";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/meera/meera.zip";
    hash = "sha256-yaqA2gYKc4OJ9YxmvQPUZ3qZFyKj0YciMaUoY1SST4I=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    find . -name "*.otf" -exec install -Dm644 {} -t "$out/share/fonts/opentype" \;
    find . -name "*.ttf" -exec install -Dm644 {} -t "$out/share/fonts/truetype" \;

    runHook postInstall
  '';

  meta = {
    description = "Meera font is a Malayalam font designed by Hussain K H and maintained by Swathanthra Malayalam Computing project. This is a comprehensive Malayalam font with 1000+ glyphs for all common Malayalam ligatures. Malayalam typeface for body text by SMC";
    homepage = "https://smc.org.in/fonts/meera";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
