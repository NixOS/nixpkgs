{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installFonts,
}:
stdenvNoCC.mkDerivation {
  pname = "rubik";
  version = "2.200";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "rubik";
    # Latest commit touching the rubik tree
    rev = "054aa9d546cd6308f8ff7139b332490e0967aebe";
    hash = "sha256-AkWMLbDIect48KLEYIIx/WNQ57P1Ivp5VrJP8mdj1oE=";
  };

  nativeBuildInputs = [ installFonts ];

  preInstall = "rm -r old/";

  meta = {
    homepage = "https://fonts.google.com/specimen/Rubik";
    description = "Rubik Font - is a 5 weight Roman + Italic family";
    longDescription = ''
      The Rubik Fonts project was initiated as part of the Chrome CubeLab
      project.

      Rubik is a 5 weight Roman + Italic family.

      Rubik supports the Latin, Cyrillic and Hebrew scripts. The Latin and Cyrillic
      were designed by Philipp Hubert and Sebastian Fischer at Hubert Fischer.

      The Hebrew was initially designed by Philipp and Sebastian, and then revised by
      type designer and Hebrew native reader Meir Sadan to adjust proportions,
      spacing and other design details.

      Cyrillic was initially designed by Philipp and Sebastian, and then revised and
      expanded by Cyreal Fonts Team (Alexei Vanyashin and Nikita Kanarev). Existing
      glyphs were improved, and glyph set was expanded to GF Cyrillic Plus.
    '';
    platforms = lib.platforms.all;
  };
}
