{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-keraleeyam";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/keraleeyam/keraleeyam.zip";
    hash = "sha256-UEhDtBaWof/2C36IapGhtYgdeQInUn+A/UAJIF7+RuA=";
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
    description = "Traditional-style Malayalam typeface designed by K H Hussain. This is the last version maintained by SMC";
    homepage = "https://smc.org.in/fonts/keraleeyam";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
