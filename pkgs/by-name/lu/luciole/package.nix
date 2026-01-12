{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "luciole";
  version = "2026-01-19";

  src = fetchzip {
    url = "https://luciole-vision.com/fonts/Luciole_webfonts.zip";
    hash = "sha256-67yd5U8RmTX+zf9qnmrnZ4WITV674DJcYWovXaS402Y=";
  };

  # The .zip contains multiple formats, only install the .ttf ones
  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype $src/Luciole_webfonts/Luciole-*/*.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://luciole-vision.com";
    description = "Sans-serif typeface optimized for visual impairment";
    longDescription = ''
      Luciole is a new typeface developed explicitly for visually impaired people.
    '';
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ AdrienCos ];
    platforms = lib.platforms.all;
  };
})
