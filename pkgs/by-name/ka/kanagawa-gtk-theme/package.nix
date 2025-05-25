{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gtk-engine-murrine,
  sassc,
  themeVariants ? [ ], # default: blue
  colorVariants ? [ ], # default: all
  sizeVariants ? [ ], # default: standard
  tweaks ? [ ],
}:
let
  pname = "kanagawa-gtk-theme";
in
lib.checkListOfEnum "${pname}: theme variants"
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
  "${pname}: color variants"
  [ "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: size variants"
  [ "standard" "compact" ]
  sizeVariants
  lib.checkListOfEnum
  "${pname}: tweaks"
  [
    "dragon"
    "black"
    "outline"
    "float"
    "macos"
  ]
  tweaks

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2025-04-24";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Kanagawa-GKT-Theme";
      rev = "825ac8d90e16ce612b487f29ee6db60b5dc63012";
      hash = "sha256-YOA3qBtMcz0to2yOStd33rF4NGhZWiLAJMo7MHx9nqM=";
    };

    nativeBuildInputs = [
      gtk3
      sassc
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    postPatch = ''
      patchShebangs ./themes/install.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes
      ./themes/install.sh --name "" \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + builtins.toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + builtins.toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "--size " + builtins.toString sizeVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + builtins.toString tweaks} \
        --dest $out/share/themes

      runHook postInstall
    '';

    meta = with lib; {
      description = "GTK theme with the Kanagawa colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ iynaix ];
      platforms = platforms.linux;
    };
  }
