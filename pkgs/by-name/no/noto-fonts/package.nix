{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  variants ? [ ],
  suffix ? "",
  longDescription ? ''
    When text is rendered by a computer, sometimes characters are
    displayed as “tofu”. They are little boxes to indicate your device
    doesn’t have a font to display the text.
    Google has been developing a font family called Noto, which aims to
    support all languages with a harmonious look and feel. Noto is
    Google’s answer to tofu. The name noto is to convey the idea that
    Google’s goal is to see “no more tofu”.  Noto has multiple styles and
    weights, and freely available to all.
  '',
}:

stdenvNoCC.mkDerivation rec {
  pname = "noto-fonts${suffix}";
  version = "2025.03.01";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notofonts.github.io";
    rev = "noto-monthly-release-${version}";
    hash = "sha256-49p4LFGywuA6zNZEw0VmtykmDUBtRkzOKYAb4sG4fK4=";
  };

  outputs = [
    "out"
    "megamerge" # Experimental fonts created by mergeing regular notofonts
  ];

  _variants = map (variant: builtins.replaceStrings [ " " ] [ "" ] variant) variants;

  installPhase =
    ''
      # We check availability in order of variable -> otf -> ttf
      # unhinted -- the hinted versions use autohint
      # maintaining maximum coverage.
      #
      # We have a mix of otf and ttf fonts
      local out_font=$out/share/fonts/noto

      install -m444 -Dt $megamerge/share/fonts/truetype/ megamerge/*.ttf
    ''
    + (
      if _variants == [ ] then
        ''
          for folder in $(ls -d fonts/*/); do
            if [[ -d "$folder"unhinted/variable-ttf ]]; then
              install -m444 -Dt $out_font "$folder"unhinted/variable-ttf/*.ttf
            elif [[ -d "$folder"unhinted/otf ]]; then
              install -m444 -Dt $out_font "$folder"unhinted/otf/*.otf
            else
              install -m444 -Dt $out_font "$folder"unhinted/ttf/*.ttf
            fi
          done
        ''
      else
        ''
          for variant in $_variants; do
            if [[ -d fonts/"$variant"/unhinted/variable-ttf ]]; then
              install -m444 -Dt $out_font fonts/"$variant"/unhinted/variable-ttf/*.ttf
            elif [[ -d fonts/"$variant"/unhinted/otf ]]; then
              install -m444 -Dt $out_font fonts/"$variant"/unhinted/otf/*.otf
            else
              install -m444 -Dt $out_font fonts/"$variant"/unhinted/ttf/*.ttf
            fi
          done
        ''
    );

  passthru.updateScript = gitUpdater {
    rev-prefix = "noto-monthly-release-";
  };

  passthru.tests = { inherit (nixosTests) noto-fonts; };

  meta = {
    description = "Beautiful and free fonts for many languages";
    homepage = "https://www.google.com/get/noto/";
    inherit longDescription;
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      mathnerd314
      emily
      jopejoe1
    ];
  };
}
