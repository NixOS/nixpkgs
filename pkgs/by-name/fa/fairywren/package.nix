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
    inherit pname;
    version = "0-unstable-2026-03-08";

    src = fetchFromGitLab {
      owner = "aiyahm";
      repo = "FairyWren-Icons";
      rev = "07bcdd4e83c4d46a698a4af60b9b8acc422af39f";
      hash = "sha256-Gzr3AiVD+IFnJa3X3wp8CAFl6SL/gD3dCrFGMDHDMos=";
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

    passthru.updateScript = unstableGitUpdater { };

    meta = {
      description = "FairyWren Icon Set";
      homepage = "https://gitlab.com/aiyahm/FairyWren-Icons";
      maintainers = with lib.maintainers; [ iamanaws ];
      platforms = lib.platforms.all;
      license = lib.licenses.gpl3Plus;
    };
  }
