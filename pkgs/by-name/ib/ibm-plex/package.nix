{
  lib,
  stdenvNoCC,
  symlinkJoin,
  fetchzip,
  installFonts,
  families ? [ ],
}:
let
  allFonts = import ./fonts.nix;
  availableFamilyNames = builtins.attrNames allFonts;
  selectedFamilies = if (families == [ ]) then availableFamilyNames else families;
  unknownFamilies = lib.subtractLists availableFamilyNames families;
  fontsToBuild = lib.filterAttrs (name: _: lib.elem name selectedFamilies) allFonts;
  makeFont =
    font:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = lib.toLower (lib.replaceStrings [ " (" ")" " " ] [ "-" "" "-" ] font.name);
      inherit (font) version;

      nativeBuildInputs = [ installFonts ];

      outputs = [
        "out"
        "webfont"
      ];

      src = fetchzip {
        inherit (font) hash url stripRoot;
      };

      # Some fonts, e.g. "ibm-plex-sans-korean" and "ibm-plex-sans-japanese"
      # include both unhinted and hinted variants of the ttf and woff/woff2 type
      # fonts, which collide when using the `installFonts` hook.
      # Default to installing the hinted variant of the fonts.
      #
      # Additionally, fonts with webfonts include complete and split forms.
      # Default to the complete forms.
      preInstall = ''
        find . -type d \( -name unhinted -or -name split \) -exec rm -rf {} +
      '';

      meta = meta // {
        description = font.name;
      };
    });
  fontDerivations = lib.mapAttrs (_: v: makeFont v) fontsToBuild;
  meta = {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      magicquark
      ners
      romildo
      ryanccn
    ];
  };
in
assert lib.assertMsg (unknownFamilies == [ ]) "Unknown font(s): ${toString unknownFamilies}";
symlinkJoin {
  pname = "ibm-plex";
  version = "0-unstable-2026-02-12";
  paths = lib.attrValues fontDerivations;
  passthru = fontDerivations // {
    updateScript = ./update.py;
  };
  inherit meta;
}
