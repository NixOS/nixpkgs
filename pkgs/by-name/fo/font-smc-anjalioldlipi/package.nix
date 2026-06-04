{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-anjalioldlipi";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/anjalioldlipi/anjalioldlipi.zip";
    hash = "sha256-c3ScpdN2h39Q6GLFL97pBBGrsillcMXmhlGilOAdF1w=";
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
    description = "A traditional style Malayalam font, designed by Kevin Siji. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/anjalioldlipi";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
