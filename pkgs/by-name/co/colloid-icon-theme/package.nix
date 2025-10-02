{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  gtk3,
  hicolor-icon-theme,
  rmlint,
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
    version = "2025-07-19";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "colloid-icon-theme";
      rev = version;
      hash = "sha256-CzFEMY3oJE3sHdIMQQi9qizG8jKo72gR8FlVK0w0p74=";
    };

    nativeBuildInputs = [
      gtk3
      rmlint
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

      # Deduplicate files and remove broken symlinks
      rmlint --types="duplicates,badlinks" \
              --config=sh:handler=symlink \
              --output=sh:$TMPDIR/rmlint.sh \
              $out/share
      if [ -f "$TMPDIR/rmlint.sh" ]; then
        sh $TMPDIR/rmlint.sh -d -q
      fi

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
