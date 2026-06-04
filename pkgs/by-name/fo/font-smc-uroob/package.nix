{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-uroob";
  version = "20241013";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/uroob/uroob.zip";
    hash = "sha256-IJcKD3cDRMA7G7foKtXtJxOrv6OeOujkq9+uGo+R/dY=";
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
    description = "Uroob is a Malayalam heading style font designed by Hussain K H. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/uroob";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
