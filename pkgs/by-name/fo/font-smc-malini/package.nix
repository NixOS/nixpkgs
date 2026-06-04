{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-malini";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/malini/Malini.zip";
    hash = "sha256-2Go6HNy2s2ZcybkuhM62UhwLehnrMMoG89YHDldflZs=";
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
    description = "Malini is a variable typeface designed for reading long-form Malayalam text set at body sizes, where clarity and typographic color matter most. Designed by Santhosh Thottingal. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/malini";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
