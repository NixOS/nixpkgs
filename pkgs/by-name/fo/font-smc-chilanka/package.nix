{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-chilanka";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/chilanka/chilanka.zip";
    hash = "sha256-z+pRvm/8alA3TbUBuR4oDD/kpvuXJTqOBlzXEKBZvnE=";
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
    description = "Casual handwriting-style Malayalam typeface by SMC";
    homepage = "https://smc.org.in/fonts/chilanka";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
