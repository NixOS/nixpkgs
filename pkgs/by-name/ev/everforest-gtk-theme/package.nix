{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  unstableGitUpdater,
  colorVariants ? [ ], # default: all variants
  sizeVariants ? [ ], # default: standard
  themeVariants ? [ ], # default: default (blue)
  tweakVariants ? [ ],
  iconVariants ? [ ],
}:

let
  pname = "everforest-gtk-theme";

  colorVariantList = [
    "light"
    "dark"
  ];
  sizeVariantList = [
    "standard"
    "compact"
  ];
  themeVariantList = [
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
  ];
  tweakVariantList = [
    "medium"
    "soft"
    "black"
    "outline"
    "float"
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
    version = "0-unstable-2024-08-05";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Everforest-GTK-Theme";
      rev = "462458b1725ddeca8a05e2248311c2da7b9b7440";
      sha256 = "sha256-mGJaDW9Kp7H8Oi26c9BuZbC31ijx2TcFYluRt2ku/zs=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];
    nativeBuildInputs = [
      gnome.gnome-shell
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

      mkdir -p "$out/share/themes"
      cd ./themes
      ./install.sh -n "Everforest" \
        ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
        ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
        -d "$out/share/themes"

      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p "$out/share/icons"
        cp -t "$out/share/icons" -a ${toString (map (v: "Everforest-${v}") iconVariants)}
      ''}

      runHook postInstall
    '';

    meta = with lib; {
      description = "Everforest colour palette for GTK";
      homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ jn-sena ];
      platforms = platforms.unix;
    };
  }
