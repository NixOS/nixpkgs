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
  pname = "gruvbox-gtk-theme";
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
    version = "0-unstable-2024-09-12";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Gruvbox-GTK-Theme";
      rev = "48faf6afee9eea5f3b8c277c936bcb9f76bd95f7";
      hash = "sha256-LAMVTDVCxjk+reS/StsVdTlsx0DrCxNLClWk6za5D5o=";
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
      ./install.sh -n Gruvbox \
      ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      -d "$out/share/themes"
      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "Gruvbox-${v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';

    meta = {
      description = "GTK theme based on the Gruvbox colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        luftmensch-luftmensch
        math-42
        d3vil0p3r
      ];
    };
  }
