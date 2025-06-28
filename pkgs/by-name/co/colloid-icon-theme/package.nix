{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  schemeVariants ? [ ],
  colorVariants ? [ ], # default is blue
}:

let
  pname = "colloid-icon-theme";

in
lib.checkListOfEnum "colloid-icon-theme: scheme variants"
  [
    "default"
    "nord"
    "dracula"
    "gruvbox"
    "everforest"
    "catppuccin"
    "all"
  ]
  schemeVariants
  lib.checkListOfEnum
  "colloid-icon-theme: color variants"
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
  colorVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2025-02-09";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "colloid-icon-theme";
      rev = version;
      hash = "sha256-x2SSaIkKm1415avO7R6TPkpghM30HmMdjMFUUyPWZsk=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    propagatedBuildInputs = [
      hicolor-icon-theme
    ];

    dontDropIconThemeCache = true;

    # These fixup steps are slow and unnecessary for this package.
    # Package may install almost 400 000 small files.
    dontPatchELF = true;
    dontRewriteSymlinks = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      name= ./install.sh \
        ${lib.optionalString (schemeVariants != [ ]) ("--scheme " + builtins.toString schemeVariants)} \
        ${lib.optionalString (colorVariants != [ ]) ("--theme " + builtins.toString colorVariants)} \
        --dest $out/share/icons

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = with lib; {
      description = "Colloid icon theme";
      homepage = "https://github.com/vinceliuice/colloid-icon-theme";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = with maintainers; [ romildo ];
    };
  }
