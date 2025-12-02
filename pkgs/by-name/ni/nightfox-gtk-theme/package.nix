{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
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
  pname = "nightfox-gtk-theme";
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
  tweakVariantList =
    map (scheme: scheme + "fox") [
      "carbon"
      "dusk"
      "nord"
      "tera"
    ]
    ++ [
      "black"
      "float"
      "outline"
      "macos"
    ];
  iconVariantList = [
    "Duskfox"
    "Duskfox-Alt"
    "Duskfox-Alt-2"
    "Duskfox-Alt-3"
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
    version = "0-unstable-2025-10-23";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Nightfox-GTK-Theme";
      rev = "f0212f2aa0d3d6cc0b313020d2d0122f313eafc9";
      hash = "sha256-KZR5vuMQnLa7AK77YB11BqgqwQHVVFfIe/rXzcocbwk=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    nativeBuildInputs = [ sassc ];
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
      ./install.sh -n Nightfox \
      ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      -d "$out/share/themes"
      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "${v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';

    meta = {
      description = "GTK theme based on the Nightfox colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Nightfox-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ d3vil0p3r ];
    };
  }
