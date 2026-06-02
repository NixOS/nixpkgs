{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-karumbi";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/karumbi/karumbi.zip";
    hash = "sha256-aeKH7CWbJNtkgv1PsaWWxyBZor+UO9q9Cctpc/qnEQU=";
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
    description = "Rounded Malayalam typeface by SMC";
    homepage = "https://smc.org.in/fonts/karumbi";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
