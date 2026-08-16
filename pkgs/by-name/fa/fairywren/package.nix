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
    version = "0-unstable-2026-07-21";

    src = fetchFromGitLab {
      owner = "FreshDoctor";
      repo = "FairyWren-Icons";
      rev = "6d578aac69b897ca4afa3bc0981cb93fa0e0df4c";
      hash = "sha256-vvE5p8l7K2jI5tw8tfX3WnjGSCVElZHB5PFX3gdT3lk=";
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
      platforms = lib.platforms.all;
      license = lib.licenses.gpl3Plus;
    };
  }
