{
  noto-fonts,
}:

noto-fonts.override {
  suffix = "-lgc-plus";

  variants = [
    "Noto Sans"
    "Noto Serif"
    "Noto Sans Mono"
    "Noto Music"
    "Noto Sans Symbols"
    "Noto Sans Symbols 2"
    "Noto Sans Math"
  ];

  longDescription = ''
    This package provides the Noto Fonts, but only for latin, greek
    and cyrillic scripts, as well as some extra fonts.
  '';
}
