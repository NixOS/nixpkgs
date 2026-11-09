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
    version = "0-unstable-2026-11-01";

    src = fetchFromGitLab {
      owner = "FreshDoctor";
      repo = "FairyWren-Icons";
      rev = "bfd1885e12d39dc21ded0b154d04642e2ebb401c";
      hash = "sha256-OFMnjVi+I/l5PmTRj810HybAMX1N3uQYqNKx18bXj74=";
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
