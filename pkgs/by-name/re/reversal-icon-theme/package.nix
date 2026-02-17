{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  jdupes,
  adwaita-icon-theme,
  hicolor-icon-theme,
  numix-icon-theme-circle,
  gitUpdater,
  allColorVariants ? false,
  colorVariants ? [ ],
}:

let
  pname = "reversal-icon-theme";
in
lib.checkListOfEnum "${pname}: color variants"
  [
    "-blue"
    "-red"
    "-pink"
    "-purple"
    "-green"
    "-orange"
    "-brown"
    "-grey"
    "-black"
    "-cyan"
  ]
  colorVariants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2025-11-14";

    src = fetchFromGitHub {
      owner = "yeyushengfan258";
      repo = "reversal-icon-theme";
      rev = "26b97f00640cd9eaeb8f196eda3a8d298158a08f";
      hash = "sha256-ahnp25wTCTrOtJUbAIv7vvVC2am+idEokoRomRe5aKU=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    propagatedBuildInputs = [
      adwaita-icon-theme
      hicolor-icon-theme
      numix-icon-theme-circle
    ];

    dontDropIconThemeCache = true;

    # These fixup steps are slow and unnecessary for this package.
    # Package may install many small files.
    dontPatchELF = true;
    dontRewriteSymlinks = true;

    # FIXME: https://github.com/yeyushengfan258/Reversal-icon-theme/issues/108
    dontCheckForBrokenSymlinks = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons

      name= ./install.sh \
        ${if allColorVariants then "-a" else toString colorVariants} \
        -d $out/share/icons

      rm $out/share/icons/*/{AUTHORS,COPYING}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "Colorful Design Rectangle icon theme";
      homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ romildo ];
    };
  }
