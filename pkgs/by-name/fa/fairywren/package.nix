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
    version = "0-unstable-2026-02-08";

    src = fetchFromGitLab {
      owner = "aiyahm";
      repo = "FairyWren-Icons";
      rev = "66295dee92a34c01174ac7fa3ac7d677d60af32e";
      hash = "sha256-6NK0+pggoezpBhOM+XxrzipT5Pv2vhSlwyEJ0M8WtBM=";
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
