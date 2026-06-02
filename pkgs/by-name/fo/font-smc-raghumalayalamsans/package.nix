{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-raghumalayalamsans";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/raghumalayalamsans/raghumalayalamsans.zip";
    hash = "sha256-rSM77MiFqRzs67mme8xkJZkw13esB9eG13j8OzytCaA=";
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
    description = "Malayalam sans-serif typeface by SMC";
    homepage = "https://smc.org.in/fonts/raghumalayalamsans";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
