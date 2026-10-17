{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
  sassc,
  themeVariants ? [ ], # default: blue
  colorVariants ? [ ], # default: all
  sizeVariants ? [ ], # default: standard
  tweaks ? [ ],
}:

let
  pname = "colloid-gtk-theme";

in
lib.checkListOfEnum "colloid-gtk-theme: theme variants"
  [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "teal"
    "grey"
    "all"
  ]
  themeVariants
  lib.checkListOfEnum
  "colloid-gtk-theme: color variants"
  [ "standard" "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "colloid-gtk-theme: size variants"
  [ "standard" "compact" ]
  sizeVariants
  lib.checkListOfEnum
  "colloid-gtk-theme: tweaks"
  [
    "nord"
    "dracula"
    "gruvbox"
    "everforest"
    "catppuccin"
    "all"
    "black"
    "rimless"
    "normal"
    "float"
  ]
  tweaks

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "2026-08-08";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "colloid-gtk-theme";
      tag = finalAttrs.version;
      hash = "sha256-2FNX5S4xN86ljj1GxHRuloP31b/QLkTCmle90NkpcpA=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    postPatch = ''
      patchShebangs install.sh

      sed -i '/"$THEME_DIR\/gtk-2.0/d' install.sh
    '';

    installPhase = ''
      runHook preInstall

      name= HOME="$TMPDIR" ./install.sh \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "--size " + toString sizeVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + toString tweaks} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "Modern and clean Gtk theme";
      homepage = "https://github.com/vinceliuice/Colloid-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = [
        lib.maintainers.chvp
        lib.maintainers.romildo
      ];
    };
  })
