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
  pname = "matrix-gtk-theme";
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
    "neo"
    "trinity"
    "black"
    "float"
    "outline"
    "macos"
  ];
  iconVariantList = [
    "Dark"
    "Light"
    "Sweet"
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
    version = "0-unstable-2024-07-22";

    src = fetchFromGitHub {
      owner = "D3vil0p3r";
      repo = "Matrix-GTK-Theme";
      rev = "f453093dffa0f46596b325c6a760afd6ea6cd810";
      hash = "sha256-DfM4nsJZvcNyUUn0opu3OM46sxhsjeeyuUuliQPrU0I=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    nativeBuildInputs = [
      gnome-shell
      sassc
    ];
    buildInputs = [ gnome-themes-extra ];

    dontBuild = true;

    passthru.updateScript = unstableGitUpdater { };

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      ./install.sh -n Matrix \
      ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      -d "$out/share/themes"
      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "Matrix-${v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';

    meta = {
      description = "GTK theme based on the Matrix colour palette";
      homepage = "https://github.com/D3vil0p3r/Matrix-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ d3vil0p3r ];
      platforms = lib.platforms.unix;
    };
  }
