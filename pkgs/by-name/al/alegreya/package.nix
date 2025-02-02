{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "alegreya";
  version = "2.008";

  src = fetchFromGitHub {
    owner = "huertatipografica";
    repo = "Alegreya";
    rev = "v${version}";
    sha256 = "1m5xr95y6qxxv2ryvhfck39d6q5hxsr51f530fshg53x48l2mpwr";
  };

  installPhase = ''
    install -D -m 444 fonts/otf/* -t $out/share/fonts/otf
    install -D -m 444 fonts/ttf/* -t $out/share/fonts/ttf
    install -D -m 444 fonts/webfonts/*.woff -t $out/share/fonts/woff
    install -D -m 444 fonts/webfonts/*.woff2 -t $out/share/fonts/woff2
  '';

  meta = with lib; {
    description = "Elegant and versatile font family for comfortable reading";
    longDescription = ''
Alegreya is a typeface originally intended for literature. Among its crowning characteristics, it conveys a dynamic and varied rhythm which facilitates the reading of long texts. Also, it provides freshness to the page while referring to the calligraphic letter, not as a literal interpretation, but rather in a contemporary typographic language.

The italic has just as much care and attention to detail in the design as the roman. The bold weights are strong, and the Black weights are really experimental for the genre. There is also a Small Caps sister family.

Not only does Alegreya provide great performance, but also achieves a strong and harmonious text by means of elements designed in an atmosphere of diversity.

The Alegreya type system is a "super family", originally intended for literature, and includes serif and sans serif sister families.

It supports expert latin, greek and cyrillic character sets and provides advanced typography OpenType features such as small caps, dynamic ligatures and fractions, four set of figures, super and subscript characters, ordinals, localized accent forms for spanish, catalan, guaraní, dutch, turkish, romanian, serbian among others.

Alegreya was chosen at the ATypI Letter2 competition in September 2011, and one of the top 14 text type systems. It was also selected in the 2nd Bienal Iberoamericana de Diseño, competition held in Madrid in 2010 and Tipos Latinos.

Designed by Juan Pablo del Peral for Huerta Tipográfica.
    '';
    homepage = "https://www.huertatipografica.com/en/fonts/alegreya-ht-pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ Thra11 ];
  };
}
