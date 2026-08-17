{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alegreya-sans";
  version = "2.008";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "huertatipografica";
    repo = "Alegreya-Sans";
    tag = "v${finalAttrs.version}";
    sha256 = "0xz5lq9fh0pj02ifazhddzh792qkxkz1z6ylj26d93wshc90jl5g";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Humanist sans serif family with a calligraphic feeling";
    longDescription = ''
      Alegreya Sans is a humanist sans serif family with a calligraphic feeling that conveys a dynamic and varied rhythm. This gives a pleasant feeling to readers of long texts.

      The family follows humanist proportions and principles, just like the serif version of the family, Alegreya. It achieves a ludic and harmonious paragraph through elements carefully designed in an atmosphere of diversity. The italics bring a strong emphasis to the roman styles, and each have seven weights to bring you a wide typographic palette.

      Alegreya Sans supports expert latin, greek and cyrillic character sets and provides advanced typography OpenType features such as small caps, dynamic ligatures and fractions, four set of figures, super and subscript characters, ordinals, localized accent forms for spanish, catalan, guaraní, dutch, turkish, romanian, serbian among others.

      The Alegreya type system is a "super family", originally intended for literature, and includes sans and serif sister families.
    '';
    homepage = "https://www.huertatipografica.com/en/fonts/alegreya-sans-ht";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Thra11 ];
  };
})
