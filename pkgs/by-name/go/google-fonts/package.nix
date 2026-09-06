{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fonts ? [ ],
}:

stdenvNoCC.mkDerivation {
  pname = "google-fonts";
  version = "0-unstable-2026-03-13";

  # Adobe Blank is split out in a separate output,
  # because it causes crashes with `libfontconfig`.
  # It has an absurd number of symbols
  outputs = [
    "out"
    "adobeBlank"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "5174b3333331c966c38f4355d50b03ca1c1df2f9";
    hash = "sha256-XvFlnyXCM69WscpY20EhKAaKYj1fs0eqmODZWx0NIPg=";
  };

  postPatch = ''
    # These directories need to be removed because they contain
    # older or duplicate versions of fonts also present in other
    # directories. This causes non-determinism in the install since
    # the installation order of font files with the same name is not
    # fixed.
    rm -rv ofl/cabincondensed \
      ofl/signikanegative \
      ofl/signikanegativesc \
      ofl/*_todelist \
      axisregistry/tests/data

    if find . -name "*.ttf" | sed 's|.*/||' | sort | uniq -c | sort -n | grep -v '^.*1 '; then
      echo "error: duplicate font names"
      exit 1
    fi
  '';

  dontBuild = true;

  # The font files are in the fonts directory and use three naming schemes:
  # FamilyName-StyleName.ttf, FamilyName[param1,param2,...].ttf, and
  # FamilyName.ttf. This installs all fonts if fonts is empty and otherwise
  # only the specified fonts by FamilyName.
  fonts = map (font: builtins.replaceStrings [ " " ] [ "" ] font) fonts;
  installPhase = ''
    adobeBlankDest=$adobeBlank/share/fonts/truetype
    install -m 444 -Dt $adobeBlankDest ofl/adobeblank/AdobeBlank-Regular.ttf
    rm -r ofl/adobeblank
    dest=$out/share/fonts/truetype
  ''
  + (
    if fonts == [ ] then
      ''
        find . -name '*.ttf' -exec install -m 444 -Dt $dest '{}' +
      ''
    else
      ''
        for font in $fonts; do
          find . \( -name "$font-*.ttf" -o -name "$font[*.ttf" -o -name "$font.ttf" \) -exec install -m 444 -Dt $dest '{}' +
        done
      ''
  );

  meta = {
    homepage = "https://fonts.google.com";
    description = "Font files available from Google Fonts";
    license = with lib.licenses; [
      asl20
      ofl
      ufl
    ];
    platforms = lib.platforms.all;
    hydraPlatforms = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
