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
    description = "Chilanka is Malayalam handwriting style font designed by Santhosh Thottingal. It follows the common style one can see in everyday handwriting of Malayalam. It has a comprehensive Malayalam glyph set that contains most of the unique Malayalam conjuncts. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/chilanka";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
