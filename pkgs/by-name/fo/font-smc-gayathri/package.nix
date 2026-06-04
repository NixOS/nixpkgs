{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-gayathri";
  version = "20241013";

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/gayathri/gayathri.zip";
    hash = "sha256-p9KZi31Na4hfUuDsKj4OXjc9s6J/8xMeuszlL5oVauQ=";
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
    description = "A gentle and modern Malayalam display typeface. Available in three weights, Gayathri is best suited for headlines, posters, titles and captions. Unicode compliant and libre licensed. Designed by Binoy Dominic. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/gayathri";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
