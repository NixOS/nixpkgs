{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "inter-alia";
  version = "0-unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "Shavian-info";
    repo = "interalia";
    rev = "5d182c4eb5511fec3879646c8b44c79ba338d53e";
    hash = "sha256-q93cCrbKc72CH/2ybJPDY5wkUZvFyCKoyQe6WhL+kAU=";
  };

  outputs = [
    "out"
    "web"
    "variable"
    "variableweb"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype instance_otf/*.otf
    install -D -m444 -t $out/share/fonts/truetype instance_ttf/*.ttf
    install -D -m444 -t $web/share/fonts/webfont instance_woff2/*.woff2
    install -D -m444 -t $variable/share/fonts/opentype variable_otf/*.otf
    install -D -m444 -t $variable/share/fonts/truetype variable_ttf/*.ttf
    install -D -m444 -t $variableweb/share/fonts/webfont variable_woff2/*.woff2

    runHook postInstall
  '';

  meta = {
    homepage = "https://shavian.info/shavian_fonts/";
    description = "Expansion of Inter typeface to support the Shavian alphabet, old-style figures, & refinements to IPA glyphs";
    longDescription = ''
          Inter Alia is an expanded version of Rasmus Andersson's beautiful open source sans serif typeface, Inter. Inter was specially designed for user interfaces with focus on high legibility of small-to-medium sized text on computer screens.

      Inter Alia builds on the features of Inter to add:

          support for the Shavian alphabet with a newly designed set of glyphs, including the letters missing from Unicode (through character variants accessed by inserting 'Variation Selector 1' (U+FE00) after 𐑒, 𐑜, 𐑢, 𐑤, 𐑻, and 𐑺)
          support for old-style figures or numerals, also known as text figures, with both proportional and tabular spacing
          refinements to International Phonetic Alphabet glyphs and other less common glyphs.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
