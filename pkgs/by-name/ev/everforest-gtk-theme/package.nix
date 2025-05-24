{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-shell,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  unstableGitUpdater,
  # By default, install both dark and light themes and icon sets
  colorVariants ? [
    "dark"
    "light"
  ],
  sizeVariants ? [ "standard" ],
  themeVariants ? [ "default" ],
  tweakVariants ? [ ],
  iconVariants ? [
    "dark"
    "light"
  ],
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
    "soft"
    "medium"
    "black"
    "float"
    "outline"
  ];
  iconVariantList = [
    "dark"
    "light"
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
    version = "0-unstable-2025-04-24";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Everforest-GTK-Theme";
      rev = "934ca11a4d38d6ef1f3854bb6950fa559e15e65c";
      hash = "sha256-U5Qsr5RH+MfKuPgexAiyQiQfLfLS4cpSJqc/+jX/53s=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    nativeBuildInputs = [
      gnome-shell
      sassc
    ];
    buildInputs = [ gnome-themes-extra ];

    dontBuild = true;

    passthru.updateScript = unstableGitUpdater { };

    # Scanning 60000+ icons can be very slow
    dontPatchShebangs = true;

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      ./install.sh -n Everforest \
      ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      -d "$out/share/themes"
      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "Everforest-${lib.toSentenceCase v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';

    # Scanning 60000+ icons can be very slow
    dontFixup = true;

    meta = with lib; {
      description = "Everforest colour palette for GTK";
      homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ jn-sena ];
      platforms = platforms.unix;
    };
  }
