{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk-engine-murrine,
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
  rec {
    inherit pname;
    version = "2025-07-31";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "colloid-gtk-theme";
      tag = version;
      hash = "sha256-0pXbeeBAkk6v2DBWfUYhWWdyrQhgr/JfDbhyS33maMM=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    postPatch = ''
      patchShebangs install.sh
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

    meta = with lib; {
      description = "Modern and clean Gtk theme";
      homepage = "https://github.com/vinceliuice/Colloid-gtk-theme";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = [ maintainers.romildo ];
    };
  }
