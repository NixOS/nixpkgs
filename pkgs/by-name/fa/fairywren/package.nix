{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  hicolor-icon-theme,
  kdePackages,
  papirus-icon-theme,
  unstableGitUpdater,
  colorVariants ? [ ], # default: install all icons
}:

let
  pname = "fairywren";
  colorVariantList = [
    "FairyWren_Dark"
    "FairyWren_Light"
  ];

in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants

  stdenvNoCC.mkDerivation
  {
    __structuredAttrs = true;
    strictDeps = true;

    inherit pname;
    version = "0-unstable-2026-11-27";

    src = fetchFromGitLab {
      owner = "FreshDoctor";
      repo = "FairyWren-Icons";
      rev = "dcdf32598224cb10d9c895a06c12b040feca1247";
      hash = "sha256-/aRXiqFUAQ9ABuSvMyBjQqiKr6CTRwTCJy1rpl7qlAc=";
    };

    propagatedBuildInputs = [
      hicolor-icon-theme
      kdePackages.breeze-icons
      papirus-icon-theme
    ];

    dontDropIconThemeCache = true;
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons
      cp -r ${
        lib.concatStringsSep " " (if colorVariants != [ ] then colorVariants else colorVariantList)
      } $out/share/icons/
      runHook postInstall
    '';

    dontFixup = true;

    passthru.updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };

    meta = {
      description = "FairyWren Icon Set";
      homepage = "https://gitlab.com/FreshDoctor/FairyWren-Icons";
      maintainers = with lib.maintainers; [ iamanaws ];
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl3Plus;
    };
  }
