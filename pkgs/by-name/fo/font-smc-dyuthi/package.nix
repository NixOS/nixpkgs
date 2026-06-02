{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-dyuthi";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/dyuthi/dyuthi.zip";
    hash = "sha256-H+2ccvHmlZjtH8KfWBSQKPtMkY/NsydHqFNaTzLS4S8=";
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
    description = "Malayalam typeface for general use by SMC";
    homepage = "https://smc.org.in/fonts/dyuthi";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
