{ callPackage }:

{
  autocomplete-all-the-things = callPackage ./urxvt-autocomplete-all-the-things { };

  bidi = callPackage ./urxvt-bidi { };

  font-size = callPackage ./urxvt-font-size { };

  perl = callPackage ./urxvt-perl { };

  perls = callPackage ./urxvt-perls { };

  resize-font = callPackage ./urxvt-resize-font { };

  tabbedex = callPackage ./urxvt-tabbedex { };

  theme-switch = callPackage ./urxvt-theme-switch { };

  vtwheel = callPackage ./urxvt-vtwheel { };

}
