{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-rachana";
  version = "20241013";

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
    description = "Traditional orthographic Malayalam typeface by SMC";
    homepage = "https://smc.org.in/fonts/rachana";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
