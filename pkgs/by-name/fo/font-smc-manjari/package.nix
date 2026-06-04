{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-manjari";
  version = "20241013";

  strictDeps = true;

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/manjari/manjari.zip";
    hash = "sha256-Sq/7UOBO54c3id6FMZeOmnZTRceEkMAAN8W+C7v7Mtw=";
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
    description = "This is a multipurpose font suitable for body and titles. This font is available in regular, bold, thin style variants. The glyph shapes follow a spiral theme, true to the beautiful curves of Malayalam. The font has comprehensive glyph set including all widely used ligatures. Designed by Santhosh Thottingal. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/manjari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
