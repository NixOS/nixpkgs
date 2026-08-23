{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  jdupes,
  sassc,
  themeVariants ? [ ], # default: blue
  colorVariants ? [ ], # default: all
  sizeVariants ? [ ], # default: standard
  tweaks ? [ ],
}:

let
  pname = "fluent-gtk-theme";

  checkThemes = lib.checkListOfEnum "${pname}: theme variants" [
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
  ] themeVariants;

  checkColors = lib.checkListOfEnum "${pname}: color variants" [
    "standard"
    "light"
    "dark"
  ] colorVariants;

  checkSizes = lib.checkListOfEnum "${pname}: size variants" [
    "standard"
    "compact"
  ] sizeVariants;

  checkTweaks = lib.checkListOfEnum "${pname}: tweaks" [
    "solid"
    "float"
    "round"
    "blur"
    "noborder"
    "square"
  ] tweaks;

  checkAll = checkThemes checkColors checkSizes checkTweaks;
in
checkAll

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "2025-04-17";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "fluent-gtk-theme";
      rev = finalAttrs.version;
      hash = "sha256-AaFj9lG9lWg0a0ksJ0ufoUpsunR3uDhcdb7oSrvAmPI=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    postPatch = ''
      patchShebangs install.sh

      sed -i '/"$THEME_DIR\/gtk-2.0/d' install.sh
    '';

    installPhase = ''
      runHook preInstall

      name= HOME="$TMPDIR" ./install.sh \
        ${lib.optionalString (themeVariants != [ ]) "--theme " + toString themeVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + toString colorVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "--size " + toString sizeVariants} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + toString tweaks} \
        --icon nixos \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "Fluent design gtk theme";
      changelog = "https://github.com/vinceliuice/Fluent-gtk-theme/releases/tag/${finalAttrs.version}";
      homepage = "https://github.com/vinceliuice/Fluent-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        luftmensch-luftmensch
        romildo
        stzx
      ];
    };
  })
