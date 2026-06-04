{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-rachana";
  version = "20241013";

  strictDeps = true;

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/rachana/rachana.zip";
    hash = "sha256-csfMs4B6BD+yap/AaWpm4kQDsR/WNMrym6szM5iZNJo=";
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
    description = "Rachana is one of the first traditional orthographic Malayalam unicode typefaces and is still widely used. Designed by K H Hussain. This is the last version maintained by SMC.";
    homepage = "https://smc.org.in/fonts/rachana";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
