{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gtk3,
  getent,
  papirus-icon-theme,
  accent ? "frostblue1",
}:
let
  validAccents = [
    "auroragreen"
    "auroragreenb"
    "auroramagenta"
    "auroramagentab"
    "auroraorange"
    "auroraorangeb"
    "aurorared"
    "auroraredb"
    "aurorayellow"
    "aurorayellowb"
    "frostblue1"
    "frostblue2"
    "frostblue3"
    "frostblue4"
    "polarnight1"
    "polarnight2"
    "polarnight3"
    "polarnight3"
    "snowstorm1"
    "snowstorm1b"
  ];
  pname = "papirus-nord";
  version = "3.2.0";
in
lib.checkListOfEnum "${pname}: accent colors" validAccents [ accent ]

  stdenvNoCC.mkDerivation
  {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "adapta-projects";
      repo = "papirus-nord";
      rev = version;
      sha256 = "sha256-KwwTDGJQ4zN9XH/pKFQDQ+EgyuSCFhN2PQAI35G+3YM=";
    };

    nativeBuildInputs = [
      gtk3
      getent
    ];

    postPatch = ''
      patchShebangs ./papirus-folders
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons
      cp -r --no-preserve=mode ${papirus-icon-theme}/share/icons/Papirus* $out/share/icons
      for size in 64x64 48x48 32x32 24x24 22x22; do
        cp -f Icons/$size/* $out/share/icons/Papirus/$size/places
      done
      for theme in $out/share/icons/*; do
          USER_HOME=$HOME DISABLE_UPDATE_ICON_CACHE=1 \
            ./papirus-folders -t $theme -o -C ${accent}
          gtk-update-icon-cache --force $theme
      done
      runHook postInstall
    '';

    meta = with lib; {
      description = "Nord version of Papirus Icon Theme";
      homepage = "https://github.com/Adapta-Projects/Papirus-Nord";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ aacebedo ];
    };
  }
