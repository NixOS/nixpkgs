{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-dyuthi";
  version = "20241013";

  strictDeps = true;
  __structuredAttrs = true;

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
    description = "Dyuthi is the first decorative Unicode font for Malayalam, designed by Hiran Venugopalan. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/dyuthi";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
