{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  gtk3,
  sassc,
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
    version = "0-unstable-2025-10-23";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Everforest-GTK-Theme";
      rev = "9b8be4d6648ae9eaae3dd550105081f8c9054825";
      hash = "sha256-XHO6NoXJwwZ8gBzZV/hJnVq5BvkEKYWvqLBQT00dGdE=";
    };

    patches = [
      # remove when merged
      # https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme/pull/34
      ./fix-install-script.patch
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    nativeBuildInputs = [
      gtk3
      sassc
    ];

    buildInputs = [
      gnome-themes-extra
    ];

    dontBuild = true;
    dontFixup = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/"{themes,icons}

      cd themes
      ./install.sh --name Everforest \
      ${lib.optionalString (colorVariants != [ ]) "--color " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "--size " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "--theme " + toString themeVariants} \
      ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      --dest "$out/share/themes"
      cd ..

      ${lib.optionalString (iconVariants != [ ]) ''
        cd icons
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "Everforest-${v}") iconVariants)} $out/share/icons/
        for theme in "$out/share/icons/"*; do
          gtk-update-icon-cache "$theme"
        done
        cd ..
      ''}

      runHook postInstall
    '';

    passthru.updateScript = unstableGitUpdater { };

    meta = {
      description = "Everforest colour palette for GTK";
      homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ jn-sena ];
      platforms = lib.platforms.unix;
    };
  }
