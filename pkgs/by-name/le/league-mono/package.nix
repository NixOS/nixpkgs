{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "league-mono";
  version = "2.300";

  src = fetchzip {
    url = "https://github.com/theleagueof/league-mono/releases/download/${finalAttrs.version}/LeagueMono-${finalAttrs.version}.tar.xz";
    hash = "sha256-b945/ej5jVzq5enyiCmgdtqB7CcfxBGR7NJFWlydK0c=";
  };

  outputs = [
    "out"
    "web"
    "variable"
    "variableweb"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/static/TTF/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/static/OTF/*.otf
    install -D -m444 -t $web/share/fonts/webfont $src/static/WOFF2/*.woff2
    install -D -m444 -t $variable/share/fonts/truetype $src/variable/TTF/*.ttf
    install -D -m444 -t $variableweb/share/fonts/webfont $src/variable/WOFF2/*.woff2

    runHook postInstall
  '';

  meta = {
    description = "monospace/variable font fun";
    longDescription = ''
      Five weights of monospace fun. League Mono is a mashup of sorts, inspired
      by some beautiful forms found in both Fira Mono, Libertinus Mono, and
      Courier(?!). League Mono was created in glyphs using masters for the
      UltraLight, Regular, and Bold weights, and interpolated instances for the
      Light and SemiBold weights. This, unfortunately, is not supported by UFO
      files, which is why there is a Glyphs source and source files for each
      weight.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/league-mono";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
