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
    version = "0-unstable-2026-09-28";

    src = fetchFromGitLab {
      owner = "FreshDoctor";
      repo = "FairyWren-Icons";
      rev = "fb00858cb2eae522952286f5df9888afe74ccdf5";
      hash = "sha256-FP5Kb57qBAgoHLq2qbGkODCVwRg1gj5Syncn6jRJquQ=";
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
