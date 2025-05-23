{
  stdenvNoCC,
  fetchurl,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "7-segment-font";
  version = "0-unstable-2025-02-09";

  src = fetchurl {
    url = "https://web.archive.org/web/20250209170057/https://torinak.com/font/7segment.ttf";
    hash = "sha256-8OnWHYNahx7meaJ1LuZNmQKGj/606x9yF/CDdfOrjjE=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 "$src" "$out/share/fonts/truetype/7segment.ttf"

    runHook postInstall
  '';

  meta = {
    description = "Font that imitates classic seven-segment LCD and LED displays";
    longDescription = ''
      A font that imitates classic seven-segment LCD and LED displays.
      Beside digits, it contains Latin letters and some symbols constructed from segments,
      with separate dot and colon as used in calculators and digital clocks.
    '';
    homepage = "https://torinak.com/font/7-segment";
    downloadPage = "https://torinak.com/font/7-segment";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ elfenermarcell ];
    platforms = lib.platforms.all;
  };
}
