{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-suruma";
  version = "20241013";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/suruma/suruma.zip";
    hash = "sha256-x4ybBr5oCwD5Stu8rRGndOYRzaV6ikE+VnLJ/src+1U=";
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
    description = "Suruma is a traditional orthography font designed by Suresh P. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/suruma";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
