{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-manjari";
  version = "20241013";

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
    description = "Elegant Malayalam typeface with thin, regular, and bold styles by SMC";
    homepage = "https://smc.org.in/fonts/manjari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
