{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  roundedIcons ? false,
  blackPanelIcons ? false,
  allColorVariants ? false,
  colorVariants ? [ ],
}:
let
  pname = "Fluent-icon-theme";
in
lib.checkListOfEnum "${pname}: available color variants"
  [
    "standard"
    "green"
    "grey"
    "orange"
    "pink"
    "purple"
    "red"
    "yellow"
    "teal"
  ]
  colorVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2025-08-21";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-icon-theme";
      tag = version;
      hash = "sha256-qAKNAbmSfVuzUGDJGVU0QF3LMc5tRzAy+l0ZwEXaJ28=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    buildInputs = [ hicolor-icon-theme ];

    # Unnecessary & slow fixup's
    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh --dest $out/share/icons \
        --name Fluent \
        ${builtins.toString colorVariants} \
        ${lib.optionalString allColorVariants "--all"} \
        ${lib.optionalString roundedIcons "--round"} \
        ${lib.optionalString blackPanelIcons "--black"}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = with lib; {
      description = "Fluent icon theme for linux desktops";
      homepage = "https://github.com/vinceliuice/Fluent-icon-theme";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ icy-thought ];
    };
  }
