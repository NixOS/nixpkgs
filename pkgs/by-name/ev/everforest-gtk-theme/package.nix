{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-shell,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  unstableGitUpdater,
  colorVariants ? [ ],
  sizeVariants ? [ ],
  themeVariants ? [ ],
  tweakVariants ? [ ],
  iconVariants ? [ ],
}:

let
  pname = "everforest-gtk-theme";
  colorVariantList = [
    "dark"
    "light"
  ];
  sizeVariantList = [
    "compact"
    "standard"
  ];
  themeVariantList = [
    "default"
    "green"
    "grey"
    "orange"
    "pink"
    "purple"
    "red"
    "teal"
    "yellow"
    "all"
  ];
  tweakVariantList = [
    "medium"
    "soft"
    "black"
    "float"
    "outline"
    "macos"
  ];
  iconVariantList = [
    "Dark"
    "Light"
  ];
in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants lib.checkListOfEnum
  "${pname}: sizeVariants"
  sizeVariantList
  sizeVariants
  lib.checkListOfEnum
  "${pname}: themeVariants"
  themeVariantList
  themeVariants
  lib.checkListOfEnum
  "${pname}: tweakVariants"
  tweakVariantList
  tweakVariants
  lib.checkListOfEnum
  "${pname}: iconVariants"
  iconVariantList
  iconVariants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2025-04-11";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Everforest-GTK-Theme";
      rev = "dbd1014f4f3b66d5258bf81e9135e0e75cea084d";
      hash = "sha256-QfawNkstj3cdIEN60dLrk3a1U4lNTclF7NLB++PrnHE=";
    };

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    nativeBuildInputs = [
      gnome-shell
      sassc
    ];
    buildInputs = [
      gnome-themes-extra
    ];

    dontBuild = true;

    passthru.updateScript = unstableGitUpdater { };

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall

      cd themes
      mkdir -p "$out/share/themes"
      ./install.sh -n Everforest \
        ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
        ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
        ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
        -d "$out/share/themes"

      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p "$out/share/icons"
        cp -a ${toString (map (v: "Everforest-${v}") iconVariants)} "$out/share/icons"
      ''}

      runHook postInstall
    '';

    meta = {
      description = "Everforest colour palette for GTK";
      homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ jn-sena ];
      platforms = lib.platforms.unix;
    };
  }
