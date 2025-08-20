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
    version = "2024-02-25";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      hash = "sha256-Cadp2+4kBZ74kdD5x0O85FszxvN6/sg6yccxughyX1Q";
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
